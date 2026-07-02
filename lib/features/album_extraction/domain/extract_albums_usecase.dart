import 'package:albumflow/features/album_extraction/domain/album.dart';
import 'package:albumflow/features/album_extraction/domain/album_filter.dart';
import 'package:albumflow/features/playlists/domain/track.dart';

/// プレイリストのトラック群からアルバム（および EP）を抽出するユースケース。
///
/// 1. `albumId` ごとにグルーピング
/// 2. フィルタ条件（シングル / コンピレーションの表示可否）を適用
/// 3. プレイリストへの追加順（古い順）に整列
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
    }).toList()..sort(_byAddedOrder);

    return albums;
  }

  /// 追加日時の古い順。追加日時が不明なものは末尾に置く。
  int _byAddedOrder(Album a, Album b) {
    final aAdded = a.addedAt;
    final bAdded = b.addedAt;
    if (aAdded == null && bAdded == null) return 0;
    if (aAdded == null) return 1;
    if (bAdded == null) return -1;
    return aAdded.compareTo(bAdded);
  }
}
