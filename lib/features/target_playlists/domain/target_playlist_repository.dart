/// 「登録先にできるプレイリスト」の設定を永続化するリポジトリ抽象。
abstract interface class TargetPlaylistRepository {
  /// 登録先に設定済みのプレイリスト ID 集合。
  Future<Set<String>> getTargetIds();

  /// 登録先プレイリスト ID 集合を保存する。
  Future<void> setTargetIds(Set<String> ids);
}
