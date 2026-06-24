import 'package:albumflow/core/router/app_router.dart';
import 'package:albumflow/core/widgets/error_view.dart';
import 'package:albumflow/core/widgets/loading_view.dart';
import 'package:albumflow/features/auth/presentation/auth_controller.dart';
import 'package:albumflow/features/playlists/presentation/playlist_card.dart';
import 'package:albumflow/features/playlists/presentation/playlists_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// プレイリスト一覧画面。
class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プレイリスト'),
        actions: <Widget>[
          IconButton(
            tooltip: '登録先の設定',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.targetSettings),
          ),
          IconButton(
            tooltip: 'ログアウト',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: playlists.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(playlistsControllerProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('プレイリストがありません'));
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(playlistsControllerProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final playlist = items[index];
                return PlaylistCard(
                  playlist: playlist,
                  onTap: () =>
                      context.push(AppRoutes.playlistAlbums(playlist.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
