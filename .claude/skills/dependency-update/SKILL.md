---
name: dependency-update
description: Dependabot設定・pub audit・flutter pub outdatedによる依存関係の自動更新とセキュリティ脆弱性スキャン。パッケージを安全かつ最新に保つ。
---

# 依存関係管理

## 概要
依存関係を手動で管理している現状から、自動更新・脆弱性スキャン・FVMによるFlutterバージョン管理を整備する。

## 脆弱性スキャン

```bash
# 既知の脆弱性をチェック（CIに組み込み推奨）
dart pub audit

# 出力例
> dart pub audit
No security advisories found.

# 脆弱性が見つかった場合
> Dependency resolution failed:
  1 security advisory found:
  - Affected package: some_package
  - Advisory: CVE-2024-XXXXX
```

## バージョン確認

```bash
# 更新可能なパッケージを確認
flutter pub outdated

# dev依存を除いた本番パッケージのみ
flutter pub outdated --no-dev-dependencies

# JSONで出力（CI解析用）
flutter pub outdated --json
```

## Dependabot 設定

```yaml
# .github/dependabot.yml
version: 2
updates:
  # Flutter/Dart パッケージ
  - package-ecosystem: pub
    directory: /
    schedule:
      interval: weekly
      day: monday
      time: "09:00"
      timezone: "Asia/Tokyo"
    open-pull-requests-limit: 5
    labels:
      - "dependencies"
      - "automated"
    commit-message:
      prefix: "chore(deps)"
    ignore:
      # メジャーバージョンは手動確認
      - dependency-name: "*"
        update-types: ["version-update:semver-major"]
      # Flutter SDK は FVM で管理
      - dependency-name: "flutter"

  # GitHub Actions
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
    labels:
      - "ci"
      - "automated"
    commit-message:
      prefix: "ci"
```

## FVM（Flutter Version Manager）

このプロジェクトはすでに`.fvmrc`でFVMを使用している。

```bash
# .fvmrc の内容確認
cat .fvmrc

# プロジェクトのFlutterバージョンをインストール
fvm install

# バージョン確認
fvm flutter --version

# Flutterを安定版の最新にアップグレード
fvm install stable --setup
fvm use stable
```

### チーム全員が同じバージョンを使うための設定

```json
// .fvmrc
{
  "flutter": "3.44.0",
  "flavors": {}
}
```

```bash
# .gitignore に追加（シンボリックリンクは除外）
echo ".fvm/flutter_sdk" >> .gitignore
```

## バージョン固定の方針

```yaml
# pubspec.yaml のベストプラクティス

dependencies:
  # パッチバージョンまで自動更新を許容
  flutter_riverpod: ^2.6.1   # >=2.6.1 <3.0.0
  
  # セキュリティ上重要なパッケージは厳格に
  flutter_secure_storage: ^9.2.2
  
  # 活発に開発中のパッケージはマイナーバージョンで固定
  go_router: ^14.8.1

dev_dependencies:
  # 開発ツールは最新を使う
  build_runner: ^2.4.15
  freezed: ^2.5.8
```

## CI でのセキュリティチェック

```yaml
# .github/workflows/ci.yml
security:
  name: Security & Dependencies
  runs-on: ubuntu-latest
  
  steps:
    - uses: actions/checkout@v4
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.44.0'
        cache: true
    
    - run: flutter pub get
    
    - name: Security audit
      run: dart pub audit
      # 脆弱性があれば exit code != 0 でCIがfail
    
    - name: Check for outdated dependencies
      run: |
        flutter pub outdated --no-dev-dependencies 2>&1 | tee outdated.txt
        # 情報として表示するのみ（failしない）
      continue-on-error: true
    
    - name: Upload outdated report
      uses: actions/upload-artifact@v4
      with:
        name: outdated-dependencies
        path: outdated.txt
        retention-days: 30
```

## パッケージ更新の手順

```bash
# 1. 現状確認
flutter pub outdated

# 2. マイナー・パッチのみ安全に更新
flutter pub upgrade

# 3. テストが通るか確認
flutter test

# 4. メジャーバージョンアップは個別に
flutter pub upgrade --major-versions some_package

# 5. 変更をコミット
git add pubspec.lock
git commit -m "chore(deps): upgrade packages"
```

## pubspec.lock の扱い

```bash
# アプリプロジェクト → コミットする（再現性のため）
git add pubspec.lock

# パッケージ（pub.devに公開するもの）→ .gitignoreに追加
echo "pubspec.lock" >> .gitignore
```

このプロジェクトはアプリなので`pubspec.lock`をコミットする。

## よくある落とし穴
- ❌ `flutter pub upgrade --major-versions`を何も確認せず実行する
- ❌ `pubspec.lock`をコミットしない（チームで環境差異が生じる）
- ❌ セキュリティアドバイザリを無視する
- ✅ Dependabotは`open-pull-requests-limit`を設定してPRが溜まりすぎないようにする
- ✅ `dart pub audit`をCIに必須で組み込む

## リファレンス
- [dart pub audit](https://dart.dev/tools/pub/cmd/pub-audit)
- [Dependabot for pub](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#package-ecosystem)
- [FVM](https://fvm.app/)
