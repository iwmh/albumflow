import 'package:albumflow/core/router/app_router.dart';
import 'package:albumflow/core/widgets/error_view.dart';
import 'package:albumflow/core/widgets/loading_view.dart';
import 'package:albumflow/features/auth/presentation/auth_controller.dart';
import 'package:albumflow/features/playlists/presentation/playlist_card.dart';
import 'package:albumflow/features/playlists/presentation/playlists_controller.dart';
import 'package:albumflow/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// プレイリスト一覧画面。
class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.playlistsScreenTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.targetSettingsTooltip,
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.targetSettings),
          ),
          IconButton(
            tooltip: l10n.logoutTooltip,
            icon: const Icon(Icons.logout),
            onPressed: () => ref
                .read(authControllerProvider.notifier)
                .logoutCommand
                .execute(),
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
            return Center(child: Text(l10n.noPlaylistsMessage));
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
