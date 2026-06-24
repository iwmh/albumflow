import 'package:albumflow/core/command/command.dart';
import 'package:albumflow/core/command/result.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/features/target_playlists/data/target_playlist_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'target_settings_controller.g.dart';

/// 登録先プレイリスト設定の ViewModel（ID 集合）。
///
/// ON/OFF の切り替えは [toggleCommand]（Commands パターン）で公開する。
@Riverpod(keepAlive: true)
class TargetSettingsController extends _$TargetSettingsController {
  late final Command1<void, String> toggleCommand = Command1<void, String>(
    _toggle,
  );

  @override
  Future<Set<String>> build() {
    ref.onDispose(toggleCommand.dispose);
    return ref.watch(targetPlaylistRepositoryProvider).getTargetIds();
  }

  /// 指定プレイリストを登録先として ON/OFF する。
  Future<Result<void>> _toggle(String playlistId) async {
    final current = <String>{...?state.value};
    if (!current.add(playlistId)) {
      current.remove(playlistId);
    }
    state = AsyncValue<Set<String>>.data(current);
    try {
      await ref.read(targetPlaylistRepositoryProvider).setTargetIds(current);
      return const Ok<void>(null);
    } on AppError catch (e) {
      return Err<void>(e);
    }
  }
}
