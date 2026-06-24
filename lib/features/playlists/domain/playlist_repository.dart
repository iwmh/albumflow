import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:albumflow/features/playlists/domain/track.dart';

/// プレイリスト関連データの単一の信頼できる情報源（抽象）。
abstract interface class PlaylistRepository {
  /// ユーザーの全プレイリスト（作成 + フォロー）をページネーション込みで取得。
  Future<List<Playlist>> getUserPlaylists();

  /// 指定プレイリストの全トラックを取得。
  Future<List<Track>> getPlaylistTracks(String playlistId);

  /// 指定アルバムの全トラック URI を取得。
  Future<List<String>> getAlbumTrackUris(String albumId);

  /// プレイリストへトラック群を追加（100 件ずつ分割）。
  Future<void> addTracksToPlaylist({
    required String playlistId,
    required List<String> trackUris,
  });
}
