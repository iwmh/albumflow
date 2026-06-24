import 'package:albumflow/features/album_extraction/domain/add_album_to_playlist_usecase.dart';
import 'package:albumflow/features/playlists/domain/playlist_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPlaylistRepository extends Mock implements PlaylistRepository {}

void main() {
  late _MockPlaylistRepository repository;
  late AddAlbumToPlaylistUseCase useCase;

  setUp(() {
    repository = _MockPlaylistRepository();
    useCase = AddAlbumToPlaylistUseCase(repository);
  });

  group('AddAlbumToPlaylistUseCase', () {
    test('アルバムの全トラック URI を対象プレイリストへ追加する', () async {
      const uris = <String>['spotify:track:1', 'spotify:track:2'];
      when(
        () => repository.getAlbumTrackUris('album1'),
      ).thenAnswer((_) async => uris);
      when(
        () => repository.addTracksToPlaylist(
          playlistId: any(named: 'playlistId'),
          trackUris: any(named: 'trackUris'),
        ),
      ).thenAnswer((_) async {});

      await useCase(albumId: 'album1', targetPlaylistId: 'playlist1');

      verify(
        () => repository.addTracksToPlaylist(
          playlistId: 'playlist1',
          trackUris: uris,
        ),
      ).called(1);
    });

    test('URI が空なら追加しない', () async {
      when(
        () => repository.getAlbumTrackUris('empty'),
      ).thenAnswer((_) async => <String>[]);

      await useCase(albumId: 'empty', targetPlaylistId: 'playlist1');

      verifyNever(
        () => repository.addTracksToPlaylist(
          playlistId: any(named: 'playlistId'),
          trackUris: any(named: 'trackUris'),
        ),
      );
    });
  });
}
