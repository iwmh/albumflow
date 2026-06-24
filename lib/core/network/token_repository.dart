import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アクセストークンの取得・更新を担う抽象。
///
/// core 層が auth 層へ依存しないために、ここでは抽象だけを定義する。
/// 実体（auth 層の `AuthRepository`）は `main.dart` の `ProviderScope` で
/// この provider を override して注入する。
abstract interface class TokenRepository {
  /// 有効なアクセストークンを返す。期限切れなら更新してから返す。
  Future<String> validAccessToken();

  /// 強制的にトークンを更新し、新しいアクセストークンを返す。
  Future<String> refresh();

  /// 保持しているトークンを破棄する（ログアウト / 認証失敗時）。
  Future<void> clear();
}

/// auth 層の実装で override される（既定では未実装）。
final tokenRepositoryProvider = Provider<TokenRepository>(
  (ref) => throw UnimplementedError(
    'tokenRepositoryProvider は main.dart の ProviderScope で '
    'authRepositoryProvider により override すること',
  ),
);
