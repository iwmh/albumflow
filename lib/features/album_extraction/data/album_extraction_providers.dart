import 'package:albumflow/features/album_extraction/domain/add_album_to_playlist_usecase.dart';
import 'package:albumflow/features/album_extraction/domain/extract_albums_usecase.dart';
import 'package:albumflow/features/playlists/data/playlist_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_extraction_providers.g.dart';

@riverpod
ExtractAlbumsUseCase extractAlbumsUseCase(Ref ref) =>
    const ExtractAlbumsUseCase();

@riverpod
AddAlbumToPlaylistUseCase addAlbumToPlaylistUseCase(Ref ref) =>
    AddAlbumToPlaylistUseCase(ref.watch(playlistRepositoryProvider));
