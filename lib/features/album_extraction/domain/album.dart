import 'package:albumflow/features/playlists/domain/track.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

/// プレイリスト内のトラックから抽出したアルバム情報（不変）。
@freezed
abstract class Album with _$Album {
  const factory Album({
    required String id,
    required String title,
    required String type,
    required int totalTracks,
    required String releaseDate,
    required int totalDurationMs,
    required List<String> artists,
    String? imageUrl,
  }) = _Album;

  const Album._();

  /// 同一アルバムのトラック群から 1 つの [Album] を統合生成する。
  factory Album.fromTracks(List<Track> tracks) {
    assert(tracks.isNotEmpty, 'tracks は空にできません');
    final first = tracks.first;
    final totalDuration = tracks.fold<int>(0, (sum, t) => sum + t.durationMs);
    final artists = <String>{for (final t in tracks) ...t.artists}.toList();
    return Album(
      id: first.albumId,
      title: first.albumName,
      type: first.albumType,
      imageUrl: first.albumImageUrl,
      totalTracks: first.albumTotalTracks,
      releaseDate: first.albumReleaseDate,
      totalDurationMs: totalDuration,
      artists: artists,
    );
  }

  /// シングルか。
  bool get isSingle => type == 'single';

  /// EP か（明示的な型がないため album かつ 4〜6 曲を EP とみなす）。
  bool get isEP => type == 'album' && totalTracks >= 4 && totalTracks <= 6;

  /// コンピレーションか。
  bool get isCompilation => type == 'compilation';

  String get artistsString => artists.join(', ');

  String get releaseYear =>
      releaseDate.isEmpty ? 'Unknown' : releaseDate.split('-').first;

  String get formattedDuration {
    final hours = totalDurationMs ~/ 3600000;
    final minutes = (totalDurationMs % 3600000) ~/ 60000;
    final seconds = (totalDurationMs % 60000) ~/ 1000;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$mm:$ss' : '$minutes:$ss';
  }
}
