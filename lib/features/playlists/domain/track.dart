import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

/// プレイリスト内のトラック（不変）。アルバム情報を内包する。
@freezed
abstract class Track with _$Track {
  const factory Track({
    required String id,
    required String name,
    required List<String> artists,
    required String albumId,
    required String albumName,
    required String albumType,
    required int albumTotalTracks,
    required String albumReleaseDate,
    required int durationMs,
    required String uri,
    String? albumImageUrl,
  }) = _Track;

  const Track._();

  /// Spotify API のトラックオブジェクト
  /// （または `{item: {...}}` / 旧 `{track: {...}}` ラッパー）から生成する。
  factory Track.fromJson(Map<String, dynamic> json) {
    final track =
        (json['item'] as Map<String, dynamic>?) ??
        (json['track'] as Map<String, dynamic>?) ??
        json;
    final album = track['album'] as Map<String, dynamic>?;
    final images = album?['images'] as List<dynamic>?;
    return Track(
      id: (track['id'] as String?) ?? '',
      name: (track['name'] as String?) ?? 'Unknown Track',
      artists:
          (track['artists'] as List<dynamic>?)
              ?.map((a) => (a as Map<String, dynamic>)['name'] as String)
              .toList() ??
          const <String>['Unknown Artist'],
      albumId: (album?['id'] as String?) ?? '',
      albumName: (album?['name'] as String?) ?? 'Unknown Album',
      albumType: (album?['album_type'] as String?) ?? 'album',
      albumImageUrl: (images != null && images.isNotEmpty)
          ? (images.first as Map<String, dynamic>)['url'] as String?
          : null,
      albumTotalTracks: (album?['total_tracks'] as num?)?.toInt() ?? 0,
      albumReleaseDate: (album?['release_date'] as String?) ?? '',
      durationMs: (track['duration_ms'] as num?)?.toInt() ?? 0,
      uri: (track['uri'] as String?) ?? '',
    );
  }

  String get artistsString => artists.join(', ');

  String get formattedDuration {
    final minutes = durationMs ~/ 60000;
    final seconds = (durationMs % 60000) ~/ 1000;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
