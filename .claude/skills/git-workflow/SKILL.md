---
name: git-workflow
description: Conventional Commits・ブランチ戦略・PRテンプレート・コミットフックによるGitワークフロー標準化。一貫したコミット履歴と自動CHANGELOGを実現する。
---

# Gitワークフロー標準化

## 概要
コミットメッセージ規約・ブランチ命名・PRテンプレートを標準化し、コード変更の追跡可能性と自動化を高める。

## Conventional Commits

### フォーマット
```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Type一覧

| Type | 用途 | 例 |
|---|---|---|
| `feat` | 新機能 | `feat(auth): add token refresh` |
| `fix` | バグ修正 | `fix(playlist): handle empty tracks` |
| `refactor` | リファクタリング | `refactor(network): migrate to dio` |
| `test` | テスト追加/修正 | `test(playlist): add repository tests` |
| `chore` | ビルド・依存関係 | `chore(deps): upgrade flutter to 3.44` |
| `docs` | ドキュメント | `docs(readme): update setup guide` |
| `perf` | パフォーマンス | `perf(list): use ListView.builder` |
| `ci` | CI/CD設定 | `ci: add coverage threshold` |
| `style` | フォーマット | `style: run dart format` |

### Scope一覧（このプロジェクト）
- `auth` — 認証関連
- `playlist` — プレイリスト機能
- `album` — アルバム機能
- `network` — ネットワーク層
- `deps` — 依存関係
- `ci` — CI/CD
- `ui` — UIコンポーネント

### 実例
```bash
feat(album): add quick-add album to playlist
fix(auth): prevent duplicate OAuth callback handling
refactor(network): replace http with dio interceptors
test(playlist): add repository mock tests
chore(deps): add freezed and riverpod_generator
ci: add coverage 80% threshold gate
```

## ブランチ戦略

```
main          ← 本番リリース済みコード（保護ブランチ）
  └── develop ← 開発統合ブランチ（オプション）
        ├── feat/album-quick-add
        ├── fix/auth-token-refresh
        ├── refactor/network-layer
        └── chore/upgrade-flutter
```

### ブランチ命名規則
```
<type>/<short-description>

# 例
feat/playlist-search
fix/oauth-callback-duplicate
refactor/migrate-to-gorouter
chore/add-freezed
```

## コミットフック（lefthook）

```yaml
# lefthook.yml
pre-commit:
  commands:
    format:
      run: dart format --output=none --set-exit-if-changed {staged_files}
      glob: "*.dart"
    analyze:
      run: flutter analyze --no-fatal-infos
      
commit-msg:
  commands:
    conventional:
      run: |
        MSG=$(cat {1})
        if ! echo "$MSG" | grep -qE "^(feat|fix|refactor|test|chore|docs|perf|ci|style)(\(.+\))?: .+"; then
          echo "❌ Conventional Commits形式が必要です"
          echo "例: feat(auth): add token refresh"
          exit 1
        fi
```

```bash
# インストール
brew install lefthook
lefthook install
```

## PRテンプレート

```markdown
<!-- .github/pull_request_template.md -->
## 概要
<!-- この変更が何をするか1〜2文で -->

## 変更の種類
- [ ] 新機能 (`feat`)
- [ ] バグ修正 (`fix`)
- [ ] リファクタリング (`refactor`)
- [ ] テスト (`test`)
- [ ] その他 (`chore`, `docs`, `ci`)

## テスト
- [ ] `flutter test` がローカルで通過
- [ ] `flutter analyze` がエラーなし
- [ ] 新機能にはユニットテストを追加
- [ ] `dart run build_runner build` 実行済み（生成コードがある場合）

## スクリーンショット（UIの変更がある場合）
<!-- Before / After のスクリーンショット -->

## 関連Issue
Closes #
```

## CHANGELOG自動生成

```yaml
# .github/workflows/changelog.yml

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Generate CHANGELOG
        uses: orhun/git-cliff-action@v4
        with:
          config: cliff.toml
          args: --verbose
        env:
          OUTPUT: CHANGELOG.md

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v2
        with:
          body_path: CHANGELOG.md
```

```toml
# cliff.toml
[changelog]
header = "# Changelog\n\n"
body = """
{% for group, commits in commits | group_by(attribute="group") %}
### {{ group | upper_first }}
{% for commit in commits %}
- {{ commit.message | upper_first }} ([{{ commit.id | truncate(length=7, end="") }}]({{ commit.id }}))
{% endfor %}
{% endfor %}
"""

[git]
conventional_commits = true
commit_parsers = [
  { message = "^feat", group = "Features" },
  { message = "^fix", group = "Bug Fixes" },
  { message = "^perf", group = "Performance" },
  { message = "^refactor", group = "Refactoring" },
]
```

## よくある落とし穴
- ❌ `fix: fixed the bug`（具体性がない）
- ❌ `WIP`や`temp`コミットをmainにマージする
- ❌ 1コミットに複数の無関係な変更を含める
- ✅ コミットは小さく、単一の目的に絞る
- ✅ `feat!:`でbreaking changeを明示する

## リファレンス
- [Conventional Commits](https://www.conventionalcommits.org/)
- [lefthook](https://github.com/evilmartians/lefthook)
- [git-cliff](https://git-cliff.org/)
