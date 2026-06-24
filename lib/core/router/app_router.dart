import 'package:albumflow/features/album_extraction/presentation/playlist_albums_screen.dart';
import 'package:albumflow/features/auth/presentation/auth_controller.dart';
import 'package:albumflow/features/auth/presentation/auth_screen.dart';
import 'package:albumflow/features/playlists/presentation/playlists_screen.dart';
import 'package:albumflow/features/target_playlists/presentation/target_settings_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// ルートパスの定義。文字列を一箇所に集約して型安全に近い形で扱う。
class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String playlists = '/';
  static const String targetSettings = '/settings/targets';
  static const String playlistAlbumsPattern = '/playlist/:playlistId';

  static String playlistAlbums(String playlistId) => '/playlist/$playlistId';
}

/// アプリのルーター。認証状態に応じてリダイレクトする。
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  // 認証状態の変化で redirect を再評価させるための Listenable。
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(isAuthenticatedProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.playlists,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loggedIn = !auth.isLoading && auth.value != null;
      final loggingIn = state.matchedLocation == AppRoutes.login;
      if (!loggedIn) return loggingIn ? null : AppRoutes.login;
      if (loggingIn) return AppRoutes.playlists;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.playlists,
        builder: (_, _) => const PlaylistsScreen(),
      ),
      GoRoute(
        path: AppRoutes.playlistAlbumsPattern,
        builder: (_, state) => PlaylistAlbumsScreen(
          playlistId: state.pathParameters['playlistId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.targetSettings,
        builder: (_, _) => const TargetSettingsScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
