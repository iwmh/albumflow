import 'package:albumflow/features/album_extraction/domain/add_album_to_playlist_usecase.dart';
import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:albumflow/features/playlists/domain/playlist_repository.dart';
import 'package:albumflow/features/playlists/domain/track.dart';
import 'package:flutter_test/flutter_test.dart';

/// 入出力だけに関心を持つ手書きの Fake。
class _FakePlaylistRepository implements PlaylistRepository {
  final Map<String, List<String>> albumTrackUris = <String, List<String>>{};
  final List<({String playlistId, List<String> trackUris})> addedCalls =
      <({String playlistId, List<String> trackUris})>[];

  @override
  Future<List<String>> getAlbumTrackUris(String albumId) async {
    return albumTrackUris[albumId] ?? <String>[];
  }

  @override
  Future<void> addTracksToPlaylist({
    required String playlistId,
    required List<String> trackUris,
  }) async {
    addedCalls.add((playlistId: playlistId, trackUris: trackUris));
  }

  @override
  Future<List<Playlist>> getUserPlaylists() async => <Playlist>[];

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) async => <Track>[];
}

void main() {
  late _FakePlaylistRepository repository;
  late AddAlbumToPlaylistUseCase useCase;

  setUp(() {
    repository = _FakePlaylistRepository();
    useCase = AddAlbumToPlaylistUseCase(repository);
  });

  group('AddAlbumToPlaylistUseCase', () {
    test('アルバムの全トラック URI を対象プレイリストへ追加する', () async {
      repository.albumTrackUris['album1'] = <String>[
        'spotify:track:1',
        'spotify:track:2',
      ];

      await useCase(albumId: 'album1', targetPlaylistId: 'playlist1');

      expect(repository.addedCalls, hasLength(1));
      expect(repository.addedCalls.single.playlistId, 'playlist1');
      expect(
        repository.addedCalls.single.trackUris,
        <String>['spotify:track:1', 'spotify:track:2'],
      );
    });

    test('URI が空なら追加しない', () async {
      await useCase(albumId: 'empty', targetPlaylistId: 'playlist1');

      expect(repository.addedCalls, isEmpty);
    });
  });
}
