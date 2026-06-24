import 'dart:convert';

import 'package:albumflow/features/auth/domain/spotify_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// トークンと PKCE の一時値を OS のセキュアストレージに保存する。
class SecureTokenStorage {
  const SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _authKey = 'spotify_auth';
  static const String _verifierKey = 'pkce_code_verifier';
  static const String _stateKey = 'pkce_state';

  Future<void> saveAuth(SpotifyAuth auth) {
    final json = jsonEncode(<String, dynamic>{
      'access_token': auth.accessToken,
      'refresh_token': auth.refreshToken,
      'expires_at': auth.expiresAt.toIso8601String(),
    });
    return _storage.write(key: _authKey, value: json);
  }

  Future<SpotifyAuth?> readAuth() async {
    final raw = await _storage.read(key: _authKey);
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return SpotifyAuth(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      expiresAt: DateTime.parse(data['expires_at'] as String),
    );
  }

  Future<void> clearAuth() => _storage.delete(key: _authKey);

  Future<void> saveOAuthState({
    required String codeVerifier,
    required String state,
  }) async {
    await _storage.write(key: _verifierKey, value: codeVerifier);
    await _storage.write(key: _stateKey, value: state);
  }

  /// 保存済みの (codeVerifier, state)。なければ `null`。
  Future<({String codeVerifier, String state})?> readOAuthState() async {
    final verifier = await _storage.read(key: _verifierKey);
    final state = await _storage.read(key: _stateKey);
    if (verifier == null || state == null) return null;
    return (codeVerifier: verifier, state: state);
  }

  Future<void> clearOAuthState() async {
    await _storage.delete(key: _verifierKey);
    await _storage.delete(key: _stateKey);
  }
}
