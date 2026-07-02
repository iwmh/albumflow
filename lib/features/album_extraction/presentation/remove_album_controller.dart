import 'package:albumflow/core/command/command.dart';
import 'package:albumflow/core/command/result.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/features/album_extraction/presentation/playlist_albums_provider.dart';
import 'package:albumflow/features/playlists/data/playlist_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remove_album_controller.g.dart';

/// プレイリスト × アルバムの組み合わせを表すマップキー。
String _removeAlbumKey(String playlistId, String albumId) =>
    '$playlistId::$albumId';

/// アルバムをプレイリストから削除する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。
@riverpod
class RemoveAlbumController extends _$RemoveAlbumController {
  final Map<String, Command0<void>> _commands = <String, Command0<void>>{};

  @override
  void build() {
    ref.onDispose(() {
      for (final command in _commands.values) {
        command.dispose();
      }
    });
  }

  /// プレイリスト × アルバムの組み合わせに対応する Command を取得する（なければ作成）。
  Command0<void> commandFor({
    required String playlistId,
    required String albumId,
  }) {
    final key = _removeAlbumKey(playlistId, albumId);
    return _commands.putIfAbsent(
      key,
      () => Command0<void>(
        () => _remove(playlistId: playlistId, albumId: albumId),
      ),
    );
  }

  Future<Result<void>> _remove({
    required String playlistId,
    required String albumId,
  }) async {
    try {
      final tracks = await ref.read(playlistTracksProvider(playlistId).future);
      final trackUris = <String>[
        for (final track in tracks)
          if (track.albumId == albumId) track.uri,
      ];
      await ref
          .read(playlistRepositoryProvider)
          .removeTracksFromPlaylist(
            playlistId: playlistId,
            trackUris: trackUris,
          );
      ref.invalidate(playlistTracksProvider(playlistId));
      return const Ok<void>(null);
    } on AppError catch (e) {
      return Err<void>(e);
    }
  }
}
