import 'package:albumflow/features/target_playlists/data/target_playlist_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'target_settings_controller.g.dart';

/// 登録先プレイリスト設定の ViewModel（ID 集合）。
@Riverpod(keepAlive: true)
class TargetSettingsController extends _$TargetSettingsController {
  @override
  Future<Set<String>> build() {
    return ref.watch(targetPlaylistRepositoryProvider).getTargetIds();
  }

  /// 指定プレイリストを登録先として ON/OFF する。
  Future<void> toggle(String playlistId) async {
    final current = <String>{...?state.value};
    if (!current.add(playlistId)) {
      current.remove(playlistId);
    }
    state = AsyncValue<Set<String>>.data(current);
    await ref.read(targetPlaylistRepositoryProvider).setTargetIds(current);
  }
}
