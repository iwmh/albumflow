import 'package:shared_preferences/shared_preferences.dart';

/// 登録先プレイリスト ID を端末ローカルに永続化する。
class TargetPlaylistStorage {
  const TargetPlaylistStorage(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const String _key = 'target_playlist_ids';

  Future<Set<String>> read() async {
    final ids = await _prefs.getStringList(_key);
    return (ids ?? const <String>[]).toSet();
  }

  Future<void> write(Set<String> ids) =>
      _prefs.setStringList(_key, ids.toList());
}
