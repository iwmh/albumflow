# AlbumFlow for Spotify — 実装計画

## 1. 目的

Spotify のプレイリストから**アルバム・EP だけを抽出**し、**ワンタップで任意のプレイリストへ登録**できるモバイルアプリ（iOS / Android）。登録先にできるプレイリストはユーザー自身が設定する。元アイデアは `spotifyalbumer` プロジェクト。本アプリは Flutter 公式 [App architecture](https://docs.flutter.dev/app-architecture/concepts) に沿ったクリーンアーキテクチャと、Riverpod のコード生成（最新のスタンダード）で構築する。

## 2. コア機能

| # | 機能 | 担当 feature |
|---|------|-------------|
| 1 | プレイリストからアルバム・EP を抽出して一覧表示 | `album_extraction` |
| 2 | アルバム全曲をワンタップで登録先プレイリストへ追加 | `album_extraction`（quick add）|
| 3 | 登録先にできるプレイリストをユーザーが設定 | `target_playlists` |

補助機能: OAuth 2.0 PKCE 認証（`auth`）、プレイリスト一覧（`playlists`）。

## 3. アーキテクチャ

Flutter 公式のレイヤを Riverpod に対応づける。依存方向は外側→内側のみ。

| 公式の概念 | 実装 |
|---|---|
| View | `ConsumerWidget` の Screen / Widget |
| ViewModel | `@riverpod` の Notifier / AsyncNotifier（`*Controller`）|
| Repository | 抽象 + 実装。単一の信頼できる情報源（SSOT）|
| Service | `SpotifyApiClient`(Dio) / `SecureTokenStorage` / `TargetPlaylistStorage`（ステートレス）|
| UseCase | `ExtractAlbumsUseCase` / `AddAlbumToPlaylistUseCase` |
| 単方向データフロー | 状態は data→Controller→View、イベントは View→Controller→Repository |
| 不変な状態 | freezed |
| Command パターン | `QuickAddController`（idle/running/success/error）|
| DI | Riverpod provider |

### ディレクトリ構成

```
lib/
├── main.dart            # ProviderScope（tokenRepositoryProvider を auth 実装で override）
├── app.dart            # MaterialApp.router + app_links でディープリンク購読
├── core/
│   ├── config/         # env.dart（dart-define）, spotify_constants.dart
│   ├── error/          # app_error.dart（freezed sealed）+ displayMessage
│   ├── network/        # spotify_dio.dart(Dio), interceptors/(auth/429/5xx),
│   │                   #   dio_error_mapper.dart, spotify_paginator.dart,
│   │                   #   token_repository.dart（抽象。core は feature 非依存）
│   ├── router/         # app_router.dart（GoRouter + 認証リダイレクト, AppRoutes）
│   ├── theme/          # app_colors.dart, app_theme.dart（Material 3 ダーク）
│   ├── observability/  # app_logger.dart
│   └── widgets/        # loading_view.dart, error_view.dart
└── features/<feature>/{data, domain, presentation}
```

## 4. データフロー（コア機能の動作）

1. **認証**: ログイン → `albumflow://callback` のディープリンクで認可コード受領 → トークン交換 → `flutter_secure_storage` 保存。`AuthInterceptor` が全 API 呼び出しにトークン付与、401 で自動リフレッシュ。
2. **抽出**: プレイリスト選択 → `playlistTracks`（ページネーションで全取得・キャッシュ）→ `ExtractAlbumsUseCase` が `albumId` でグルーピングし種別判定（single / EP=album かつ 4〜6 曲 / compilation）→ フィルタ適用 → `playlistAlbums` として導出。フィルタ変更時はトラックを再取得しない。
3. **ワンタップ登録**: 登録先チップをタップ → `AddAlbumToPlaylistUseCase` がアルバム全トラック URI を取得 → 対象プレイリストへ 100 件ずつ追加。`QuickAddController` が（アルバム×登録先）ごとに実行状態を保持し、チップ表示を切り替える。
4. **登録先設定**: 全プレイリストをチェックボックス表示 → 選択 ID 集合を `shared_preferences` に永続化 → `selectedTargetPlaylists` が一覧と突き合わせて登録先 `Playlist` を導出。

## 5. 主要な設計判断

- **Riverpod 3.x + riverpod_generator 4.x**: 最新のスタンダード。関数プロバイダーは `Ref`、`AsyncValue` の値は `.value`（`valueOrNull` は廃止）。
- **freezed 3**: モデルは `abstract` / union は `sealed`。Spotify の深いネスト JSON は `fromJson` を手書きで解釈し、サブモデル乱立を回避。
- **core を feature 非依存に保つ**: トークン管理は `core/network/token_repository.dart` の抽象として定義し、`main.dart` の `ProviderScope` で auth 実装（`authRepositoryProvider`）を override 注入。
- **エラーは型付き**: `AppError`（freezed sealed）に集約。`mapDioException` で `DioException → AppError` 変換。
- **秘密情報を持たない**: `client_id` は `--dart-define=SPOTIFY_CLIENT_ID`。リダイレクトは `albumflow://callback`。
- **riverpod_lint / custom_lint は一時的に不採用**: Riverpod 3.3.x 未対応のため。対応版が出たら再有効化（`analysis_options.yaml` 参照）。

## 6. テスト

- `ExtractAlbumsUseCase`: グルーピング / シングル除外 / EP 判定 / 空 albumId 無視 / 並び順。
- `AddAlbumToPlaylistUseCase`: 追加呼び出し / URI 空時のスキップ（mocktail で Repository をモック）。
- `Track.fromJson` / `Album.fromTracks`: JSON 解釈 / 合計時間・アーティスト重複排除。

実行: `fvm flutter test`。CI（`.github/workflows/ci.yml`）で build_runner → format → analyze(`--fatal-infos`) → test --coverage。

## 7. 残作業（アプリ外部の設定）

- [ ] Spotify Developer Dashboard で新規アプリ登録（Redirect URI `albumflow://callback`）し `client_id` を取得
- [ ] `flutterfire configure` で Firebase 実プロジェクトに接続（`firebase.json` / `firebase_options.dart` / google-services 系を生成）し、`main.dart` の Firebase 初期化を有効化
- [ ] GitHub Secrets を登録（`SPOTIFY_CLIENT_ID` / 署名 / App Store Connect / Firebase）
- [ ] アプリアイコン（`assets/icon/app_icon.png`）を差し替えて `flutter_launcher_icons` 実行

## 8. 今後の拡張余地

- `go_router_builder` による完全な型安全ルーティング
- アルバム詳細・トラック一覧画面
- 登録の取り消し（重複検出）、検索、ライブラリ（保存済みアルバム）連携
- Crashlytics / Performance 監視の本番有効化（`/observability` スキル参照）
