import 'package:albumflow/features/playlists/domain/playlist_repository.dart';

/// アルバム全体を対象プレイリストへ追加するユースケース。
///
/// アルバムの全トラック URI を取得し、対象プレイリストへ一括追加する。
class AddAlbumToPlaylistUseCase {
  const AddAlbumToPlaylistUseCase(this._repository);

  final PlaylistRepository _repository;

  Future<void> call({
    required String albumId,
    required String targetPlaylistId,
  }) async {
    final uris = await _repository.getAlbumTrackUris(albumId);
    if (uris.isEmpty) return;
    await _repository.addTracksToPlaylist(
      playlistId: targetPlaylistId,
      trackUris: uris,
    );
  }
}
