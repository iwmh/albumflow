import 'package:albumflow/core/theme/app_colors.dart';
import 'package:albumflow/features/album_extraction/domain/album.dart';
import 'package:albumflow/features/album_extraction/presentation/quick_add_controller.dart';
import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アルバム 1 件のカード。登録先ごとのワンタップ登録チップを持つ。
class AlbumListItem extends StatelessWidget {
  const AlbumListItem({required this.album, required this.targets, super.key});

  final Album album;
  final List<Playlist> targets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Artwork(imageUrl: album.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        album.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        album.artistsString,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          _TypeBadge(album: album),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${album.releaseYear} ・ ${album.totalTracks} 曲 '
                              '・ ${album.formattedDuration}',
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (targets.isEmpty)
              const _NoTargetsHint()
            else ...<Widget>[
              Text('登録先', style: theme.textTheme.labelMedium),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <Widget>[
                  for (final target in targets)
                    _QuickAddChip(album: album, target: target),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickAddChip extends ConsumerWidget {
  const _QuickAddChip({required this.album, required this.target});

  final Album album;
  final Playlist target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      quickAddControllerProvider.select(
        (m) => m[quickAddKey(album.id, target.id)] ?? QuickAddStatus.idle,
      ),
    );

    final (Widget avatar, bool enabled) = switch (status) {
      QuickAddStatus.idle => (const Icon(Icons.add, size: 18), true),
      QuickAddStatus.running => (
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        false,
      ),
      QuickAddStatus.success => (
        const Icon(Icons.check, size: 18, color: AppColors.spotifyGreen),
        true,
      ),
      QuickAddStatus.error => (const Icon(Icons.refresh, size: 18), true),
    };

    return ActionChip(
      avatar: avatar,
      label: Text(
        target.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: enabled
          ? () async {
              await ref
                  .read(quickAddControllerProvider.notifier)
                  .add(albumId: album.id, targetPlaylistId: target.id);
              if (!context.mounted) return;
              final result = ref
                  .read(quickAddControllerProvider.notifier)
                  .statusFor(albumId: album.id, targetId: target.id);
              final message = result == QuickAddStatus.success
                  ? '「${target.name}」に「${album.title}」を追加しました'
                  : '追加に失敗しました。もう一度お試しください';
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          : null,
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final label = album.isSingle
        ? 'Single'
        : album.isEP
        ? 'EP'
        : album.isCompilation
        ? 'Comp.'
        : 'Album';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.spotifyGreen.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.spotifyGreen),
      ),
    );
  }
}

class _NoTargetsHint extends StatelessWidget {
  const _NoTargetsHint();

  @override
  Widget build(BuildContext context) {
    return Text(
      '登録先プレイリストが未設定です。右上の設定から追加してください。',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 72.0;
    const placeholder = SizedBox(
      width: size,
      height: size,
      child: ColoredBox(
        color: AppColors.darkGray,
        child: Icon(Icons.album),
      ),
    );
    final url = imageUrl;
    if (url == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => placeholder,
      ),
    );
  }
}
