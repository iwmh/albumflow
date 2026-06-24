import 'package:albumflow/features/playlists/data/playlist_providers.dart';
import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlists_controller.g.dart';

/// ユーザーのプレイリスト一覧の ViewModel。
@riverpod
class PlaylistsController extends _$PlaylistsController {
  @override
  Future<List<Playlist>> build() {
    return ref.watch(playlistRepositoryProvider).getUserPlaylists();
  }

  Future<void> refresh() async {
    state = const AsyncValue<List<Playlist>>.loading();
    state = await AsyncValue.guard(
      () => ref.read(playlistRepositoryProvider).getUserPlaylists(),
    );
  }
}
