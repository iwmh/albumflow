import 'package:albumflow/core/command/command.dart';
import 'package:albumflow/core/command/result.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/features/album_extraction/data/album_extraction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_add_controller.g.dart';

/// アルバム × 登録先の組み合わせを表すマップキー。
String quickAddKey(String albumId, String targetId) => '$albumId::$targetId';

/// アルバム × 登録先ごとのワンタップ登録を実行する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。
@riverpod
class QuickAddController extends _$QuickAddController {
  final Map<String, Command0<void>> _commands = <String, Command0<void>>{};

  @override
  void build() {
    ref.onDispose(() {
      for (final command in _commands.values) {
        command.dispose();
      }
    });
  }

  /// アルバム × 登録先の組み合わせに対応する Command を取得する（なければ作成）。
  Command0<void> commandFor({
    required String albumId,
    required String targetId,
  }) {
    final key = quickAddKey(albumId, targetId);
    return _commands.putIfAbsent(
      key,
      () => Command0<void>(
        () => _add(albumId: albumId, targetPlaylistId: targetId),
      ),
    );
  }

  Future<Result<void>> _add({
    required String albumId,
    required String targetPlaylistId,
  }) async {
    try {
      await ref.read(addAlbumToPlaylistUseCaseProvider)(
        albumId: albumId,
        targetPlaylistId: targetPlaylistId,
      );
      return const Ok<void>(null);
    } on AppError catch (e) {
      return Err<void>(e);
    }
  }
}
