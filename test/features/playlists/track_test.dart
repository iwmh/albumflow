import 'package:albumflow/features/album_extraction/domain/album.dart';
import 'package:albumflow/features/playlists/domain/track.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Track.fromJson', () {
    test('playlist tracks の {track: {...}} 形式を解釈する', () {
      final json = <String, dynamic>{
        'track': <String, dynamic>{
          'id': 't1',
          'name': 'Song',
          'duration_ms': 200000,
          'uri': 'spotify:track:t1',
          'artists': <dynamic>[
            <String, dynamic>{'name': 'Artist A'},
            <String, dynamic>{'name': 'Artist B'},
          ],
          'album': <String, dynamic>{
            'id': 'al1',
            'name': 'My Album',
            'album_type': 'album',
            'total_tracks': 10,
            'release_date': '2021-05-01',
            'images': <dynamic>[
              <String, dynamic>{'url': 'https://img/1.jpg'},
            ],
          },
        },
      };

      final track = Track.fromJson(json);

      expect(track.id, 't1');
      expect(track.artists, <String>['Artist A', 'Artist B']);
      expect(track.albumId, 'al1');
      expect(track.albumImageUrl, 'https://img/1.jpg');
      expect(track.formattedDuration, '3:20');
    });

    test('欠損フィールドは安全な既定値になる', () {
      final track = Track.fromJson(<String, dynamic>{
        'track': <String, dynamic>{},
      });

      expect(track.id, '');
      expect(track.albumName, 'Unknown Album');
      expect(track.artists, <String>['Unknown Artist']);
    });
  });

  group('Album.fromTracks', () {
    test('複数トラックから合計時間とアーティスト重複排除を行う', () {
      final tracks = <Track>[
        const Track(
          id: '1',
          name: 'a',
          artists: <String>['A'],
          albumId: 'al',
          albumName: 'Album',
          albumType: 'album',
          albumTotalTracks: 2,
          albumReleaseDate: '2020',
          durationMs: 1000,
          uri: 'spotify:track:1',
        ),
        const Track(
          id: '2',
          name: 'b',
          artists: <String>['A', 'B'],
          albumId: 'al',
          albumName: 'Album',
          albumType: 'album',
          albumTotalTracks: 2,
          albumReleaseDate: '2020',
          durationMs: 2000,
          uri: 'spotify:track:2',
        ),
      ];

      final album = Album.fromTracks(tracks);

      expect(album.totalDurationMs, 3000);
      expect(album.artists, containsAll(<String>['A', 'B']));
      expect(album.artists.length, 2);
    });
  });
}
