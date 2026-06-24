import 'package:albumflow/features/album_extraction/data/album_extraction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_add_controller.g.dart';

/// ワンタップ登録の実行状態。
enum QuickAddStatus { idle, running, success, error }

/// アルバム × 登録先の組み合わせを表すマップキー。
String quickAddKey(String albumId, String targetId) => '$albumId::$targetId';

/// アルバム × 登録先ごとの実行状態を保持する Command パターンの ViewModel。
///
/// 状態は `quickAddKey(albumId, targetId) -> QuickAddStatus` のマップ。
@riverpod
class QuickAddController extends _$QuickAddController {
  @override
  Map<String, QuickAddStatus> build() => const <String, QuickAddStatus>{};

  QuickAddStatus statusFor({
    required String albumId,
    required String targetId,
  }) => state[quickAddKey(albumId, targetId)] ?? QuickAddStatus.idle;

  /// アルバムを対象プレイリストへ追加する。
  Future<void> add({
    required String albumId,
    required String targetPlaylistId,
  }) async {
    final key = quickAddKey(albumId, targetPlaylistId);
    if (state[key] == QuickAddStatus.running) return;

    state = <String, QuickAddStatus>{...state, key: QuickAddStatus.running};
    try {
      await ref.read(addAlbumToPlaylistUseCaseProvider)(
        albumId: albumId,
        targetPlaylistId: targetPlaylistId,
      );
      state = <String, QuickAddStatus>{...state, key: QuickAddStatus.success};
    } on Object {
      state = <String, QuickAddStatus>{...state, key: QuickAddStatus.error};
    }
  }
}
