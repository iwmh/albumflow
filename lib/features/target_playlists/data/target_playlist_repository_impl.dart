import 'package:albumflow/features/target_playlists/data/target_playlist_storage.dart';
import 'package:albumflow/features/target_playlists/domain/target_playlist_repository.dart';

class TargetPlaylistRepositoryImpl implements TargetPlaylistRepository {
  const TargetPlaylistRepositoryImpl(this._storage);

  final TargetPlaylistStorage _storage;

  @override
  Future<Set<String>> getTargetIds() => _storage.read();

  @override
  Future<void> setTargetIds(Set<String> ids) => _storage.write(ids);
}
