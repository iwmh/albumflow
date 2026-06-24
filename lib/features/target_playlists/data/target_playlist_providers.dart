import 'package:albumflow/features/target_playlists/data/target_playlist_repository_impl.dart';
import 'package:albumflow/features/target_playlists/data/target_playlist_storage.dart';
import 'package:albumflow/features/target_playlists/domain/target_playlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'target_playlist_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferencesAsync sharedPreferences(Ref ref) => SharedPreferencesAsync();

@Riverpod(keepAlive: true)
TargetPlaylistRepository targetPlaylistRepository(Ref ref) =>
    TargetPlaylistRepositoryImpl(
      TargetPlaylistStorage(ref.watch(sharedPreferencesProvider)),
    );
