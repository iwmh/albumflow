import 'package:albumflow/features/playlists/domain/playlist.dart';
import 'package:albumflow/features/playlists/presentation/playlists_controller.dart';
import 'package:albumflow/features/target_playlists/presentation/target_settings_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_target_playlists_provider.g.dart';

/// 登録先に設定されたプレイリストを、名前付きの [Playlist] として導出する。
@riverpod
Future<List<Playlist>> selectedTargetPlaylists(Ref ref) async {
  final all = await ref.watch(playlistsControllerProvider.future);
  final ids = await ref.watch(targetSettingsControllerProvider.future);
  return all.where((p) => ids.contains(p.id)).toList();
}
