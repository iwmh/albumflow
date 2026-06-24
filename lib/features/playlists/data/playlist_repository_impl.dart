import 'package:albumflow/core/config/spotify_constants.dart';
import 'package:albumflow/core/network/dio_error_mapper.dart';
import 'package:albumflow/core/network/spotify_paginator.dart';
import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:albumflow/features/playlists/domain/playlist_repository.dart';
import 'package:albumflow/features/playlists/domain/track.dart';
import 'package:dio/dio.dart';

/// [PlaylistRepository] の実装（Spotify Web API）。
class PlaylistRepositoryImpl implements PlaylistRepository {
  PlaylistRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Playlist>> getUserPlaylists() {
    return _guard(resource: 'プレイリスト', () async {
      final items = await fetchAllItems(
        _dio,
        '/me/playlists',
        queryParameters: <String, dynamic>{'limit': 50},
      );
      return items
          .where((item) => item['id'] != null)
          .map(Playlist.fromJson)
          .toList();
    });
  }

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) {
    return _guard(resource: 'トラック', () async {
      final items = await fetchAllItems(
        _dio,
        '/playlists/$playlistId/tracks',
        queryParameters: <String, dynamic>{'limit': 100},
      );
      return items
          // ローカル / 削除済みトラックを除外。
          .where((item) => item['track'] != null && item['is_local'] != true)
          .map(Track.fromJson)
          .where((t) => t.id.isNotEmpty)
          .toList();
    });
  }

  @override
  Future<List<String>> getAlbumTrackUris(String albumId) {
    return _guard(resource: 'アルバム', () async {
      final items = await fetchAllItems(
        _dio,
        '/albums/$albumId/tracks',
        queryParameters: <String, dynamic>{'limit': 50},
      );
      return items
          .map((item) => item['uri'] as String?)
          .whereType<String>()
          .toList();
    });
  }

  @override
  Future<void> addTracksToPlaylist({
    required String playlistId,
    required List<String> trackUris,
  }) {
    if (trackUris.isEmpty) return Future<void>.value();
    return _guard(resource: 'プレイリスト', () async {
      const batchSize = SpotifyConstants.addTracksBatchSize;
      for (var i = 0; i < trackUris.length; i += batchSize) {
        final end = (i + batchSize < trackUris.length)
            ? i + batchSize
            : trackUris.length;
        await _dio.post<Map<String, dynamic>>(
          '/playlists/$playlistId/tracks',
          data: <String, dynamic>{'uris': trackUris.sublist(i, end)},
        );
      }
    });
  }

  Future<T> _guard<T>(
    Future<T> Function() body, {
    required String resource,
  }) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw mapDioException(e, resource: resource);
    }
  }
}
