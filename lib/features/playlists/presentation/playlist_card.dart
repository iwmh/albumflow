import 'package:albumflow/core/theme/app_colors.dart';
import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// プレイリスト一覧の 1 行。
class PlaylistCard extends StatelessWidget {
  const PlaylistCard({required this.playlist, required this.onTap, super.key});

  final Playlist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: _Artwork(imageUrl: playlist.imageUrl),
      title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${playlist.totalTracks} 曲'
        '${playlist.ownerDisplayName != null ? ' ・ ${playlist.ownerDisplayName}' : ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    const placeholder = SizedBox(
      width: size,
      height: size,
      child: ColoredBox(
        color: AppColors.darkGray,
        child: Icon(Icons.queue_music),
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
