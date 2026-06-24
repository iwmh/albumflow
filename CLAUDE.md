# AlbumFlow for Spotify

Spotify のプレイリストから**アルバム・EP だけを抽出**し、**ワンタップで任意のプレイリストへ登録**できる Flutter モバイルアプリ（iOS / Android）。登録先プレイリストはユーザー自身が設定できる。

**コア技術:** Flutter 3.44（FVM）/ Dart 3.12 / Riverpod 3.x（`@riverpod` コード生成）/ freezed 3 / Dio / GoRouter / Spotify Web API（OAuth 2.0 PKCE）/ Material Design 3

## 必須コマンド

```bash
fvm dart run build_runner build  # コード生成（生成ファイルはコミットする）
fvm dart run build_runner watch  # ウォッチモード
fvm dart format lib test         # フォーマット（build/ は対象外）
fvm flutter analyze              # 静的解析（警告 0 を維持）
fvm flutter test                 # テスト
fvm flutter run --dart-define=SPOTIFY_CLIENT_ID=<your_client_id>  # 実行
fvm flutter clean && fvm flutter pub get  # クリーンビルド
```

> `client_id` は `--dart-define=SPOTIFY_CLIENT_ID=...`（または `--dart-define-from-file=env.json`）で注入する。**コードにハードコードしない。**

## アーキテクチャ

Flutter 公式 [App architecture](https://docs.flutter.dev/app-architecture/concepts) のレイヤリングを Riverpod に対応づけたクリーンアーキテクチャ。feature-first × レイヤ明示。

```
lib/
├── main.dart            # ProviderScope（tokenRepositoryProvider を override）
├── app.dart            # MaterialApp.router + ディープリンク購読
├── core/               # 横断的関心事
│   ├── config/         # env（dart-define）, spotify_constants
│   ├── error/          # AppError（freezed sealed）
│   ├── network/        # spotify_dio(Dio) + interceptors, paginator, token_repository(抽象)
│   ├── router/         # GoRouter（認証リダイレクト）
│   ├── theme/          # Material 3 テーマ
│   └── widgets/        # 共通 View（Loading/Error）
└── features/<feature>/
    ├── data/           # Repository 実装・Service・DTO 解析
    ├── domain/         # freezed モデル・Repository 抽象・UseCase
    └── presentation/   # Screen(View) + Controller(ViewModel, @riverpod)
```

| 公式の概念 | 本プロジェクトでの実装 |
|---|---|
| View | `ConsumerWidget` の Screen / Widget |
| ViewModel | `@riverpod` の Notifier / AsyncNotifier（`*Controller`） |
| Repository | `*Repository`（抽象 + 実装）。単一の信頼できる情報源 |
| Service | `SpotifyApiClient`(Dio) / `SecureTokenStorage` / `TargetPlaylistStorage`（ステートレス） |
| UseCase | `ExtractAlbumsUseCase` / `AddAlbumToPlaylistUseCase` |
| Command | `Command0` / `Command1`（`core/command/`）。ユーザー操作（ボタン押下）の実行中・成功・失敗を ViewModel が公開 |

依存方向: `View → Controller → UseCase/Repository(抽象) → Repository実装 → Service`。外側→内側のみ。`core` は feature に依存しない（auth のトークン実装は `tokenRepositoryProvider` の override で注入）。

## Riverpod パターン（コード生成）

```dart
// ViewModel（@riverpod 必須）
@riverpod
class FeatureController extends _$FeatureController {
  @override
  Future<State> build() => ref.watch(repositoryProvider).fetch();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(repositoryProvider).fetch());
  }
}

// View（すべての AsyncValue 状態を処理）
ref.watch(featureControllerProvider).when(
  data: (data) => DataView(data),
  loading: () => const LoadingView(),
  error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(featureControllerProvider)),
);
```

- **Riverpod 3 注意:** `AsyncValue` の値取得は `.value`（`T?` を返す）。`valueOrNull` は存在しない。
- 関数プロバイダーの引数は `Ref ref`（生成された `FooRef` は廃止）。
- `ref.watch` はビルド、`ref.read` はコールバック。
- `riverpod_annotation` を import すれば `Ref` / `AsyncValue` 等も使える（`flutter_riverpod` の重複 import は不要）。

## Commands パターン（ユーザー操作）

ボタン押下など UI からの直接的なユーザー操作は、ViewModel のメソッドを直接呼ぶのではなく `core/command/command.dart` の `Command0`（引数なし）/ `Command1`（引数 1 つ）でラップする。実行中・成功・失敗の状態は `ChangeNotifier` として公開され、View は `ListenableBuilder` で監視する（[Flutter App architecture: Recommendations](https://docs.flutter.dev/app-architecture/recommendations) の Commands パターン）。

```dart
// ViewModel
late final Command0<void> loginCommand = Command0<void>(_login);

Future<Result<void>> _login() async {
  try {
    await ref.read(authRepositoryProvider).startLogin();
    return const Ok<void>(null);
  } on AppError catch (e) {
    return Err<void>(e);
  }
}

// View
ListenableBuilder(
  listenable: loginCommand,
  builder: (context, _) => FilledButton(
    onPressed: loginCommand.running ? null : loginCommand.execute,
    child: loginCommand.running ? const CircularProgressIndicator() : const Text('ログイン'),
  ),
)
```

- 結果は `Result<T>`（`core/command/result.dart`）の `Ok` / `Err` で表現する。`Err` は必ず `AppError` を保持する。
- ディープリンクのコールバック完了など、ユーザーの直接操作ではない非同期処理は通常の `AsyncValue` パターン（`state = await AsyncValue.guard(...)`）のままで良い。
- `Command` は `ChangeNotifier` のため、Controller の `build()` 内で `ref.onDispose(...)` から `dispose()` を呼ぶ。

## コード生成（freezed 3 / riverpod_generator）

```dart
// データモデル（freezed 3 では abstract / sealed が必須）
@freezed
abstract class Playlist with _$Playlist {
  const factory Playlist({required String id, required String name, @Default(0) int totalTracks}) = _Playlist;
  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(/* 手書きで Spotify JSON を解釈 */);
}

// 状態の sealed class
@freezed
sealed class AppError with _$AppError implements Exception {
  const factory AppError.authExpired() = AuthExpiredError;
  const factory AppError.network({required String message}) = NetworkError;
}
```

**生成ファイル（`.g.dart` / `.freezed.dart`）はコミットする**（CI で build_runner 不要）。Spotify の深いネスト JSON は `fromJson` を手書きで解釈し、json_serializable のサブモデル乱立を避ける。

## エラーハンドリング

`core/error/app_error.dart` の `AppError`（freezed sealed: authExpired / network / rateLimited / server / notFound / unknown）を使う。Repository は `core/network/dio_error_mapper.dart` の `mapDioException` で `DioException → AppError` 変換。**素の `throw Exception(...)` は禁止。**

## Spotify API

- **認証**: OAuth 2.0 PKCE。トークンは `flutter_secure_storage`。リダイレクト `albumflow://callback`。
- **エンドポイント**: `/me/playlists`、`/playlists/{id}/tracks`、`/albums/{id}/tracks`、`POST /playlists/{id}/tracks`。
- **401**: `AuthInterceptor` が自動リフレッシュして 1 回再試行。
- **429**: `RateLimitInterceptor` が `Retry-After` 秒待機して再試行。**5xx**: `RetryInterceptor` が指数バックオフ。
- **ページネーション**: `core/network/spotify_paginator.dart` の `fetchAllItems`（`next` が null まで）。
- **絶対禁止**: `client_id`/`client_secret` のハードコード。

## 静的解析（`very_good_analysis`）

CI: `fvm flutter analyze --fatal-infos --fatal-warnings`。生成ファイルと `build/` は解析対象外（`analysis_options.yaml`）。

> **riverpod_lint / custom_lint は現時点で Riverpod 3.3.x に未対応**のため依存から外している。対応版が出たら dev_dependencies に追加し、`analysis_options.yaml` に `analyzer: plugins: [custom_lint]` を記述して再有効化すること。

## コーディング規約

- ファイル: `snake_case.dart` / クラス: `PascalCase` / 変数: `camelCase`
- `const` を使えるところでは必ず使う / `BuildContext` を非同期ギャップをまたいで保持しない（`context.mounted` で確認）
- `StatefulWidget` は最小限（ディープリンク購読など）/ `print` 禁止（`AppLogger` を使う）
- デバッグコード・コメントアウト・マジックナンバーを残さない

## テスト

Repository / Service のテストダブルは、mocktail の `Mock` ではなく**手書きの Fake**（抽象クラスを実装し、入出力だけに関心を持つ）を優先する。Fake は実装の詳細に依存しないため、リファクタリング耐性が高い。

```dart
class _FakePlaylistRepository implements PlaylistRepository {
  final Map<String, List<String>> albumTrackUris = {};
  @override
  Future<List<String>> getAlbumTrackUris(String albumId) async =>
      albumTrackUris[albumId] ?? [];
  // ...
}
```

mocktail は依存に残してあるが、Fake で表現しづらいケース（呼び出し回数の厳密な検証など）に限定して使う。

## 品質チェックリスト

- [ ] `fvm flutter analyze` で警告なし
- [ ] `fvm flutter test` 通過
- [ ] すべての AsyncValue 状態を処理（data/loading/error）
- [ ] `fvm dart format lib test` 適用済み
- [ ] `fvm dart run build_runner build` 実行済み（生成ファイルが最新）
- [ ] アクセシビリティ（セマンティクス、48dp タッチターゲット、コントラスト 4.5:1 以上）

## 利用可能なスキル（`.claude/skills/`）

| スキル | 用途 |
|--------|------|
| `/feature-developer` | 新機能の実装ワークフロー |
| `/code-reviewer` | コードレビューチェックリスト |
| `/debugger` `/systematic-debug` | バグ診断・根本原因調査 |
| `/tdd` `/testing` | テスト駆動開発・テスト戦略 |
| `/improve-architecture` | アーキテクチャ改善 |
| `/network-layer` | Dio + Interceptor の保守・拡張 |
| `/navigation` | GoRouter の保守・拡張 |
| `/mobile-release` `/observability` `/ci-cd` | リリース・監視・CI/CD |
| `/dependency-update` `/git-workflow` `/ux` | 依存更新・Git 運用・UX |
