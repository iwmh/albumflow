import 'package:albumflow/features/auth/data/auth_providers.dart';
import 'package:albumflow/features/auth/domain/spotify_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<SpotifyAuth?> build() {
    return ref.watch(authRepositoryProvider).currentAuth();
  }

  /// ログイン開始（外部ブラウザで認可画面を開く）。
  Future<void> login() async {
    await ref.read(authRepositoryProvider).startLogin();
  }

  /// ディープリンクのコールバックを受けてログインを完了する。
  Future<void> completeLogin({
    required String code,
    required String returnedState,
  }) async {
    state = const AsyncValue<SpotifyAuth?>.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .completeLogin(code: code, returnedState: returnedState),
    );
  }

  /// ログアウト。
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue<SpotifyAuth?>.data(null);
  }
}

/// 認証済みかどうか（ルーティング用）。
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(authControllerProvider).value != null;
}
