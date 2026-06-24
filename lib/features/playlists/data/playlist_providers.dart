import 'package:albumflow/core/network/spotify_dio.dart';
import 'package:albumflow/features/playlists/data/playlist_repository_impl.dart';
import 'package:albumflow/features/playlists/domain/playlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_providers.g.dart';

@Riverpod(keepAlive: true)
PlaylistRepository playlistRepository(Ref ref) =>
    PlaylistRepositoryImpl(ref.watch(spotifyDioProvider));
