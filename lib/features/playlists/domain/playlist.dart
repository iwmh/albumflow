import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist.freezed.dart';

/// Spotify のプレイリスト（不変）。
@freezed
abstract class Playlist with _$Playlist {
  const factory Playlist({
    required String id,
    required String name,
    required int totalTracks,
    String? description,
    String? imageUrl,
    String? ownerId,
    String? ownerDisplayName,
  }) = _Playlist;

  /// Spotify API のプレイリストオブジェクトから生成する。
  factory Playlist.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>?;
    final owner = json['owner'] as Map<String, dynamic>?;
    // 2026年2月の Web API 移行で `tracks` は非推奨となり `items` に統合された。
    // 旧 API（`tracks` のみ返す）との互換のため両方を見る。
    final items = json['items'] as Map<String, dynamic>?;
    final tracks = json['tracks'] as Map<String, dynamic>?;
    return Playlist(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? '(名称未設定)',
      totalTracks:
          (items?['total'] as num?)?.toInt() ??
          (tracks?['total'] as num?)?.toInt() ??
          0,
      description: json['description'] as String?,
      imageUrl: (images != null && images.isNotEmpty)
          ? (images.first as Map<String, dynamic>)['url'] as String?
          : null,
      ownerId: owner?['id'] as String?,
      ownerDisplayName: owner?['display_name'] as String?,
    );
  }
}
