import 'package:albumflow/core/router/app_router.dart';
import 'package:albumflow/core/widgets/error_view.dart';
import 'package:albumflow/core/widgets/loading_view.dart';
import 'package:albumflow/features/album_extraction/presentation/album_filter_controller.dart';
import 'package:albumflow/features/album_extraction/presentation/album_list_item.dart';
import 'package:albumflow/features/album_extraction/presentation/playlist_albums_provider.dart';
import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:albumflow/features/playlists/presentation/playlists_controller.dart';
import 'package:albumflow/features/target_playlists/presentation/selected_target_playlists_provider.dart';
import 'package:albumflow/l10n/generated/app_localizations.dart';
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
    final sourcePlaylists = ref.watch(playlistsControllerProvider).value;
    final sourcePlaylistName = _findPlaylistName(sourcePlaylists, playlistId);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(sourcePlaylistName ?? l10n.albumsScreenFallbackTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.targetSettingsTooltip,
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.targetSettings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SwitchListTile(
            title: Text(l10n.includeSinglesLabel),
            value: filter.includeSingles,
            onChanged: (_) => ref
                .read(albumFilterControllerProvider.notifier)
                .toggleSingles(),
          ),
          const Divider(height: 1),
          Expanded(
            child: albums.when(
              // 引き下げ更新（依存プロバイダの invalidate による再取得）の間も
              // 直前の一覧を表示したままにする。
              skipLoadingOnReload: true,
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                error: error,
                onRetry: () =>
                    ref.invalidate(playlistTracksProvider(playlistId)),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return Center(child: Text(l10n.noAlbumsMessage));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(playlistTracksProvider(playlistId));
                    await ref.read(playlistAlbumsProvider(playlistId).future);
                  },
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => AlbumListItem(
                      playlistId: playlistId,
                      album: list[index],
                      targets: targets,
                    ),
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

/// 前画面（プレイリスト一覧）で取得済みのキャッシュからプレイリスト名を探す。
String? _findPlaylistName(List<Playlist>? playlists, String playlistId) {
  if (playlists == null) return null;
  for (final playlist in playlists) {
    if (playlist.id == playlistId) return playlist.name;
  }
  return null;
}
