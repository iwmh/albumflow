import 'package:albumflow/features/album_extraction/domain/album_filter.dart';
import 'package:albumflow/features/album_extraction/domain/extract_albums_usecase.dart';
import 'package:albumflow/features/playlists/domain/track.dart';
import 'package:flutter_test/flutter_test.dart';

Track _track({
  required String albumId,
  String albumType = 'album',
  int albumTotalTracks = 10,
  int durationMs = 200000,
  String releaseDate = '2020-01-01',
  List<String> artists = const <String>['Artist A'],
}) {
  return Track(
    id: 'track_${albumId}_$durationMs',
    name: 'name',
    artists: artists,
    albumId: albumId,
    albumName: 'Album $albumId',
    albumType: albumType,
    albumTotalTracks: albumTotalTracks,
    albumReleaseDate: releaseDate,
    durationMs: durationMs,
    uri: 'spotify:track:$albumId',
  );
}

void main() {
  const useCase = ExtractAlbumsUseCase();

  group('ExtractAlbumsUseCase', () {
    test('albumId ごとにグルーピングしアルバムを生成する', () {
      final tracks = <Track>[
        _track(albumId: 'a', durationMs: 100),
        _track(albumId: 'a', durationMs: 200),
        _track(albumId: 'b', durationMs: 300),
      ];

      final albums = useCase(tracks);

      expect(albums, hasLength(2));
      final albumA = albums.firstWhere((al) => al.id == 'a');
      expect(albumA.totalDurationMs, 300); // 100 + 200 を合算
    });

    test('既定ではシングルを除外する', () {
      final tracks = <Track>[
        _track(albumId: 'album1'),
        _track(albumId: 'single1', albumType: 'single', albumTotalTracks: 1),
      ];

      final albums = useCase(tracks);

      expect(albums.map((a) => a.id), <String>['album1']);
    });

    test('includeSingles 指定でシングルも含める', () {
      final tracks = <Track>[
        _track(albumId: 'album1'),
        _track(albumId: 'single1', albumType: 'single', albumTotalTracks: 1),
      ];

      final albums = useCase(
        tracks,
        filter: const AlbumFilter(includeSingles: true),
      );

      expect(
        albums.map((a) => a.id),
        containsAll(<String>['album1', 'single1']),
      );
    });

    test('4〜6 曲の album は EP と判定される', () {
      final tracks = <Track>[
        _track(albumId: 'ep', albumTotalTracks: 5),
      ];

      final albums = useCase(tracks);

      expect(albums.single.isEP, isTrue);
    });

    test('albumId が空のトラックは無視する', () {
      final tracks = <Track>[
        _track(albumId: ''),
        _track(albumId: 'valid'),
      ];

      final albums = useCase(tracks);

      expect(albums.map((a) => a.id), <String>['valid']);
    });

    test('リリース日の新しい順に並ぶ', () {
      final tracks = <Track>[
        _track(albumId: 'old', releaseDate: '2010-01-01'),
        _track(albumId: 'new', releaseDate: '2023-01-01'),
      ];

      final albums = useCase(tracks);

      expect(albums.map((a) => a.id), <String>['new', 'old']);
    });
  });
}
