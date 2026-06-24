# AlbumFlow for Spotify

Spotify のプレイリストから**アルバム・EP だけを抽出**し、**ワンタップで任意のプレイリストへ登録**できる Flutter アプリ（iOS / Android）。

## 主な機能

1. 🎵 **プレイリストからアルバム・EP を抽出** — トラックをアルバム単位にまとめ、シングルを除外して一覧表示
2. ⚡ **ワンタップ登録** — アルバム全曲を、選んだ登録先プレイリストへ一括追加
3. ⚙️ **登録先プレイリストの設定** — どのプレイリストを登録先にするかをユーザー自身が選択（端末ローカルに永続化）

## 技術スタック

Flutter 3.44（FVM）/ Dart 3.12 / Riverpod 3.x（`@riverpod` コード生成）/ freezed 3 / Dio / GoRouter / Spotify Web API（OAuth 2.0 PKCE）/ Material Design 3

アーキテクチャの詳細は [`docs/IMPLEMENTATION_PLAN.md`](docs/IMPLEMENTATION_PLAN.md) と [`CLAUDE.md`](CLAUDE.md) を参照。

## セットアップ

### 1. 前提

- [FVM](https://fvm.app/) で Flutter 3.44.0（`.fvmrc` でピン済み）

```bash
fvm install      # 必要なら 3.44.0 を取得
fvm flutter pub get
fvm dart run build_runner build   # 生成ファイルはコミット済みだが、初回は実行推奨
```

### 2. Spotify アプリの登録

[Spotify Developer Dashboard](https://developer.spotify.com/dashboard) でアプリを作成し、

- **Redirect URI** に `albumflow://callback` を登録
- **Client ID** を控える

### 3. Client ID を注入して起動

`client_id` はソースにハードコードせず、`--dart-define` で注入する。

```bash
# 方法 A: 直接指定
fvm flutter run --dart-define=SPOTIFY_CLIENT_ID=<your_client_id>

# 方法 B: env.json（.gitignore 対象）を使う
cp env.example.json env.json   # 中身を編集
fvm flutter run --dart-define-from-file=env.json
```

## 開発コマンド

```bash
fvm dart run build_runner watch   # コード生成（ウォッチ）
fvm dart format lib test          # フォーマット
fvm flutter analyze               # 静的解析（警告 0）
fvm flutter test                  # テスト
```

## ディレクトリ構成

```
lib/
├── core/          # config / error / network(Dio+Interceptor) / router(GoRouter) / theme
└── features/<feature>/{data, domain, presentation}
    ├── auth                # OAuth 2.0 PKCE 認証
    ├── playlists           # プレイリスト一覧
    ├── album_extraction    # アルバム・EP 抽出 ＋ ワンタップ登録
    └── target_playlists    # 登録先プレイリストの設定
```

## CI/CD

`.github/workflows/` に解析・テスト・Android/iOS ビルド・Firebase App Distribution・ストア配信のワークフローを用意。実行には以下の GitHub Secrets が必要（`APP_RELEASE_GUIDE*.md` 参照）:

- `SPOTIFY_CLIENT_ID`
- Android 署名: `KEYSTORE_BASE64` ほか
- iOS 配信: `APP_STORE_CONNECT_API_KEY_BASE64` ほか
- Firebase: `FIREBASE_SERVICE_ACCOUNT_JSON`, `FIREBASE_APP_ID_ANDROID`, `FIREBASE_APP_ID_IOS`

> Firebase 連携（`firebase.json` / `google-services.json` / `GoogleService-Info.plist` / `firebase_options.dart`）はプレースホルダ。`flutterfire configure` で実プロジェクトに接続してから有効化する。

## プライバシー

[`PRIVACY.md`](PRIVACY.md) を参照。
