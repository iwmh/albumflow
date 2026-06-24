---
name: navigation
description: GoRouterによる宣言的・型安全なルーティングとディープリンク統合の保守・拡張。
---

# ナビゲーション（GoRouter）

## 概要
`core/router/app_router.dart` に GoRouter を実装済み（`goRouterProvider`）。認証状態に応じたリダイレクトと、OAuth コールバック（`albumflow://callback`）のディープリンク処理を備える。パスは `AppRoutes` に集約。本スキルはルート追加・型安全化（`go_router_builder` 導入など）・リダイレクト調整の保守・拡張に使う。

## パッケージ追加

```yaml
dependencies:
  go_router: ^14.8.1
```

## ルート定義

```dart
// lib/shared/navigation/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      return authState.when(
        loading: () => '/splash',
        error: (_, __) => '/auth',
        data: (auth) {
          if (auth == null || auth.isExpired) return '/auth';
          if (state.matchedLocation == '/auth') return '/playlists';
          return null;
        },
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: '/auth/callback',
        redirect: (context, state) {
          // OAuthコールバック処理
          final code = state.uri.queryParameters['code'];
          final authState = state.uri.queryParameters['state'];
          final error = state.uri.queryParameters['error'];
          // コールバック処理はAuthProviderで行う
          return '/playlists';
        },
      ),
      GoRoute(
        path: '/playlists',
        builder: (_, __) => const PlaylistsScreen(),
        routes: [
          GoRoute(
            path: ':playlistId',
            builder: (_, state) => PlaylistDetailScreen(
              playlistId: state.pathParameters['playlistId']!,
            ),
          ),
        ],
      ),
    ],
  );
}
```

## main.dart への統合

```dart
class AlbumFlowApp extends ConsumerWidget {
  const AlbumFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AlbumFlow for Spotify',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
```

## ディープリンク統合（OAuth コールバック）

GoRouterはディープリンクを自動処理できる。`AndroidManifest.xml`と`Info.plist`の設定はそのままで、`app_links`の手動ハンドリングをGoRouterに委譲できる。

```dart
// GoRouterのonExceptionで未知のディープリンクを処理
GoRouter(
  onException: (context, state, router) {
    router.go('/playlists');
  },
  // ...
)
```

## 型安全なナビゲーション（typed routes）

より型安全にするには`TypedGoRoute`を使用：

```dart
// lib/shared/navigation/routes.dart
part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();
}

@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData {
  const AuthRoute();
}

@TypedGoRoute<PlaylistsRoute>(
  path: '/playlists',
  routes: [
    TypedGoRoute<PlaylistDetailRoute>(path: ':playlistId'),
  ],
)
class PlaylistsRoute extends GoRouteData {
  const PlaylistsRoute();
}

class PlaylistDetailRoute extends GoRouteData {
  const PlaylistDetailRoute({required this.playlistId});
  final String playlistId;
}

// 使用例
context.go(const PlaylistsRoute());
context.push(PlaylistDetailRoute(playlistId: '123'));
```

## 現状からの移行

| 旧 | 新 |
|---|---|
| `Navigator.push(context, MaterialPageRoute(...))` | `context.push('/playlists/$id')` |
| `Navigator.pop(context)` | `context.pop()` |
| `app_links`での手動ディープリンク処理 | GoRouterが自動処理 |
| `main.dart`でのAuthState切り替え | GoRouterの`redirect`で宣言的に管理 |

## テスト

```dart
testWidgets('未ログイン時はAuthScreenにリダイレクト', (tester) async {
  final container = ProviderContainer(overrides: [
    authProvider.overrideWith((ref) => const AsyncValue.data(null)),
  ]);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: container.read(appRouterProvider),
      ),
    ),
  );

  await tester.pumpAndSettle();
  expect(find.byType(AuthScreen), findsOneWidget);
});
```

## よくある落とし穴
- ❌ GoRouterインスタンスをRiverpodの外で作る（authStateの変化が反映されない）
- ❌ `context.go()`と`context.push()`の混同（goはスタックをリセット）
- ✅ `redirect`でauthStateを監視してページ切り替えを宣言的に管理
- ✅ ディープリンクはGoRouterに委譲して`app_links`の手動ハンドリングを削除

## リファレンス
- [GoRouter ドキュメント](https://pub.dev/packages/go_router)
- [GoRouter Redirection](https://pub.dev/documentation/go_router/latest/topics/Redirection-topic.html)
