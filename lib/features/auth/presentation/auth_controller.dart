import 'package:albumflow/core/command/command.dart';
import 'package:albumflow/core/command/result.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/features/auth/data/auth_providers.dart';
import 'package:albumflow/features/auth/domain/spotify_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
/// ログイン・ログアウトの実行状態は [loginCommand] / [logoutCommand]
/// （Commands パターン）で公開する。
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  late final Command0<void> loginCommand = Command0<void>(_login);
  late final Command0<void> logoutCommand = Command0<void>(_logout);

  @override
  Future<SpotifyAuth?> build() {
    ref.onDispose(() {
      loginCommand.dispose();
      logoutCommand.dispose();
    });
    return ref.watch(authRepositoryProvider).currentAuth();
  }

  Future<Result<void>> _login() async {
    try {
      await ref.read(authRepositoryProvider).startLogin();
      return const Ok<void>(null);
    } on AppError catch (e) {
      return Err<void>(e);
    }
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

  Future<Result<void>> _logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
      state = const AsyncValue<SpotifyAuth?>.data(null);
      return const Ok<void>(null);
    } on AppError catch (e) {
      return Err<void>(e);
    }
  }
}

/// 認証済みかどうか（ルーティング用）。
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(authControllerProvider).value != null;
}
