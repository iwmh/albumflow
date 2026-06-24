import 'package:albumflow/core/network/token_repository.dart';
import 'package:albumflow/features/auth/domain/spotify_auth.dart';

/// 認証のユースケースを束ねるリポジトリ抽象。
///
/// アクセストークン管理（[TokenRepository]）も担い、ネットワーク層へ注入される。
abstract interface class AuthRepository implements TokenRepository {
  /// 保存済みの認証情報（未ログインなら `null`）。
  Future<SpotifyAuth?> currentAuth();

  /// PKCE フローを開始し、外部ブラウザで認可画面を開く。
  /// 完了はディープリンクのコールバックで [completeLogin] を呼んで行う。
  Future<void> startLogin();

  /// 認可コードをトークンに交換してログインを完了する。
  Future<SpotifyAuth> completeLogin({
    required String code,
    required String returnedState,
  });

  /// ログアウト（保存済みトークンを破棄）。
  Future<void> logout();
}
