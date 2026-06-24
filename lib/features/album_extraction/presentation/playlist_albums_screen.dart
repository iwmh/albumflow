import 'package:albumflow/core/router/app_router.dart';
import 'package:albumflow/core/widgets/error_view.dart';
import 'package:albumflow/core/widgets/loading_view.dart';
import 'package:albumflow/features/album_extraction/presentation/album_filter_controller.dart';
import 'package:albumflow/features/album_extraction/presentation/album_list_item.dart';
import 'package:albumflow/features/album_extraction/presentation/playlist_albums_provider.dart';
import 'package:albumflow/features/target_playlists/presentation/selected_target_playlists_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// プレイリストから抽出したアルバム・EP の一覧画面。
class PlaylistAlbumsScreen extends ConsumerWidget {
  const PlaylistAlbumsScreen({required this.playlistId, super.key});

  final String playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(playlistAlbumsProvider(playlistId));
    final filter = ref.watch(albumFilterControllerProvider);
    final targets =
        ref.watch(selectedTargetPlaylistsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('アルバム・EP'),
        actions: <Widget>[
          IconButton(
            tooltip: '登録先の設定',
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.targetSettings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: const Text('シングルも表示'),
            value: filter.includeSingles,
            onChanged: (_) => ref
                .read(albumFilterControllerProvider.notifier)
                .toggleSingles(),
          ),
          const Divider(height: 1),
          Expanded(
            child: albums.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                error: error,
                onRetry: () =>
                    ref.invalidate(playlistTracksProvider(playlistId)),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('アルバム・EP がありません'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(playlistTracksProvider(playlistId));
                    await ref.read(playlistAlbumsProvider(playlistId).future);
                  },
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        AlbumListItem(album: list[index], targets: targets),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
