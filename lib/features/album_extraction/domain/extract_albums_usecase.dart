import 'package:albumflow/features/album_extraction/domain/album.dart';
import 'package:albumflow/features/album_extraction/domain/album_filter.dart';
import 'package:albumflow/features/playlists/domain/track.dart';

/// プレイリストのトラック群からアルバム（および EP）を抽出するユースケース。
///
/// 1. `albumId` ごとにグルーピング
/// 2. フィルタ条件（シングル / コンピレーションの表示可否）を適用
/// 3. リリース日の新しい順に整列
class ExtractAlbumsUseCase {
  const ExtractAlbumsUseCase();

  List<Album> call(
    List<Track> tracks, {
    AlbumFilter filter = const AlbumFilter(),
  }) {
    final grouped = <String, List<Track>>{};
    for (final track in tracks) {
      if (track.albumId.isEmpty) continue;
      grouped.putIfAbsent(track.albumId, () => <Track>[]).add(track);
    }

    final albums = grouped.values.map(Album.fromTracks).where((album) {
      if (!filter.includeSingles && album.isSingle) return false;
      if (!filter.includeCompilations && album.isCompilation) return false;
      return true;
    }).toList()..sort((a, b) => b.releaseDate.compareTo(a.releaseDate));

    return albums;
  }
}
