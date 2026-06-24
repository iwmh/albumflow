import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/features/auth/data/secure_token_storage.dart';
import 'package:albumflow/features/auth/data/spotify_auth_service.dart';
import 'package:albumflow/features/auth/domain/auth_repository.dart';
import 'package:albumflow/features/auth/domain/spotify_auth.dart';
import 'package:url_launcher/url_launcher.dart';

/// [AuthRepository] の実装。PKCE フローとトークンの保持・更新を担う。
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service, this._storage);

  final SpotifyAuthService _service;
  final SecureTokenStorage _storage;

  @override
  Future<SpotifyAuth?> currentAuth() => _storage.readAuth();

  @override
  Future<void> startLogin() async {
    final codeVerifier = _service.generateRandomString(128);
    final state = _service.generateRandomString(16);
    await _storage.saveOAuthState(codeVerifier: codeVerifier, state: state);

    final uri = _service.buildAuthorizeUri(
      codeChallenge: _service.codeChallenge(codeVerifier),
      state: state,
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw const AppError.unknown(cause: '認可画面を開けませんでした');
    }
  }

  @override
  Future<SpotifyAuth> completeLogin({
    required String code,
    required String returnedState,
  }) async {
    final stored = await _storage.readOAuthState();
    if (stored == null || stored.state != returnedState) {
      // CSRF 対策: state 不一致は拒否。
      throw const AppError.unknown(cause: 'state パラメータが一致しません');
    }
    final auth = await _service.exchangeCode(
      code: code,
      codeVerifier: stored.codeVerifier,
    );
    await _storage.saveAuth(auth);
    await _storage.clearOAuthState();
    return auth;
  }

  @override
  Future<void> logout() => _storage.clearAuth();

  // --- TokenRepository ---

  @override
  Future<String> validAccessToken() async {
    final auth = await _storage.readAuth();
    if (auth == null) throw const AppError.authExpired();
    if (auth.isExpiringSoon) return refresh();
    return auth.accessToken;
  }

  @override
  Future<String> refresh() async {
    final auth = await _storage.readAuth();
    if (auth == null) throw const AppError.authExpired();
    final refreshed = await _service.refresh(auth.refreshToken);
    await _storage.saveAuth(refreshed);
    return refreshed.accessToken;
  }

  @override
  Future<void> clear() => _storage.clearAuth();
}
