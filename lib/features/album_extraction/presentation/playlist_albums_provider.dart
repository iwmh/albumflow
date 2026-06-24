import 'package:albumflow/features/album_extraction/data/album_extraction_providers.dart';
import 'package:albumflow/features/album_extraction/domain/album.dart';
import 'package:albumflow/features/album_extraction/presentation/album_filter_controller.dart';
import 'package:albumflow/features/playlists/data/playlist_providers.dart';
import 'package:albumflow/features/playlists/domain/track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_albums_provider.g.dart';

/// プレイリストのトラックを取得（ネットワーク）。フィルタ変更では再取得しないようキャッシュする。
@riverpod
Future<List<Track>> playlistTracks(Ref ref, String playlistId) {
  return ref.watch(playlistRepositoryProvider).getPlaylistTracks(playlistId);
}

/// キャッシュ済みトラックから、フィルタを適用したアルバム一覧を導出する。
@riverpod
Future<List<Album>> playlistAlbums(Ref ref, String playlistId) async {
  final tracks = await ref.watch(playlistTracksProvider(playlistId).future);
  final filter = ref.watch(albumFilterControllerProvider);
  return ref.read(extractAlbumsUseCaseProvider)(tracks, filter: filter);
}
