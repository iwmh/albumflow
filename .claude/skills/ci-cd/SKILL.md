---
name: ci-cd
description: GitHub ActionsのCI/CDパイプライン強化。コード生成ステップ追加・カバレッジ閾値ゲート・依存関係キャッシュ最適化・セキュリティスキャンを実装する。
---

# CI/CD パイプライン強化

## 概要
現状のCIに不足している「コード生成の検証」「カバレッジ閾値」「セキュリティスキャン」を追加し、品質ゲートを確立する。

## 強化版 ci.yml

```yaml

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main, develop]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

env:
  FLUTTER_VERSION: '3.44.0'
  MIN_COVERAGE: 80

jobs:
  analyze-and-test:
    name: Analyze & Test
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: stable
          cache: true

      - name: Get dependencies
        run: flutter pub get

      # ── コード生成 ──────────────────────────────
      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Check generated files are committed
        run: |
          if ! git diff --exit-code "*.g.dart" "*.freezed.dart"; then
            echo "::error::Generated files are out of date. Run 'dart run build_runner build' locally."
            exit 1
          fi

      # ── 静的解析 ────────────────────────────────
      - name: Check formatting
        run: dart format --output=none --set-exit-if-changed .

      - name: Analyze code
        run: flutter analyze --fatal-infos --fatal-warnings

      - name: Run custom lint
        run: dart run custom_lint

      # ── テスト + カバレッジ ─────────────────────
      - name: Run tests with coverage
        run: flutter test --coverage --coverage-path=coverage/lcov.info

      - name: Remove generated files from coverage
        run: |
          sudo apt-get install -y lcov
          lcov --remove coverage/lcov.info \
            '*.g.dart' '*.freezed.dart' 'lib/main.dart' \
            -o coverage/lcov.info

      - name: Check coverage threshold
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -oP '\d+\.\d+(?=%)')
          echo "Coverage: ${COVERAGE}%"
          if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
            echo "::error::Coverage ${COVERAGE}% is below minimum ${MIN_COVERAGE}%"
            exit 1
          fi

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info
          fail_ci_if_error: false

  # ── セキュリティスキャン ────────────────────────
  security:
    name: Security Scan
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: stable
          cache: true

      - name: Get dependencies
        run: flutter pub get

      - name: Check for known vulnerabilities
        run: dart pub audit

      - name: Check for outdated dependencies
        run: flutter pub outdated --no-dev-dependencies || true
        # 情報目的（failしない）

  build-android:
    name: Build Android (debug)
    runs-on: ubuntu-latest
    needs: analyze-and-test

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
          cache: gradle

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: stable
          cache: true

      - run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build APK (debug)
        run: flutter build apk --debug

      - uses: actions/upload-artifact@v4
        with:
          name: debug-apk
          path: build/app/outputs/flutter-apk/app-debug.apk
          retention-days: 7

  build-ios:
    name: Build iOS (no codesign)
    runs-on: macos-latest
    needs: analyze-and-test

    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: stable
          cache: true

      - run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build iOS (no codesign)
        run: flutter build ios --no-codesign --debug
```

## カバレッジ閾値の設定基準

| 段階 | 閾値 | 説明 |
|---|---|---|
| 導入期 | 60% | 既存コードに合わせた現実的な目標 |
| 安定期 | 80% | **推奨値**（クリティカルパスをカバー） |
| 成熟期 | 90% | 高品質ライブラリ水準 |

## Dependabot（依存関係自動更新）

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: pub
    directory: /
    schedule:
      interval: weekly
      day: monday
    open-pull-requests-limit: 5
    labels:
      - dependencies
    ignore:
      # メジャーバージョンアップは手動で確認
      - dependency-name: "*"
        update-types: ["version-update:semver-major"]

  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
```

## PR テンプレート

```markdown
<!-- .github/pull_request_template.md -->
## 変更内容
<!-- 何を変更したか -->

## テスト
- [ ] ユニットテスト追加/更新済み
- [ ] `flutter test` がローカルで通過
- [ ] `flutter analyze` がエラーなし
- [ ] `dart run build_runner build` 実行済み（コード生成がある場合）

## チェックリスト
- [ ] breaking change なし（ある場合は説明を追記）
- [ ] カバレッジが低下していない
```

## ブランチ保護ルール（GitHub Settings）

- `main`ブランチへの直プッシュ禁止
- PR必須（レビュワー1名以上）
- CIすべてパス必須：`analyze-and-test`, `security`, `build-android`, `build-ios`
- カバレッジ低下でブロック（Codecovと連携）

## よくある落とし穴
- ❌ `dart run build_runner build`をCIに入れ忘れる（生成ファイルを手動コミットせず）
- ❌ 生成ファイルを`.gitignore`に追加するとCIで再生成が必要になる
- ✅ 生成ファイルはコミット対象にして、CIで「変更がないこと」を検証する
