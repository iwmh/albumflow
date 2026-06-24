import 'dart:convert';
import 'dart:math';

import 'package:albumflow/core/config/env.dart';
import 'package:albumflow/core/config/spotify_constants.dart';
import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/core/network/dio_error_mapper.dart';
import 'package:albumflow/features/auth/domain/spotify_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// OAuth 2.0 PKCE の低レベル処理（ステートレス）。
///
/// トークンエンドポイントへは認証インターセプターを通さない素の Dio を使う。
class SpotifyAuthService {
  SpotifyAuthService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const String _verifierChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  /// 暗号学的に安全なランダム文字列。
  String generateRandomString(int length) {
    final random = Random.secure();
    return List<String>.generate(
      length,
      (_) => _verifierChars[random.nextInt(_verifierChars.length)],
    ).join();
  }

  /// code_verifier から S256 の code_challenge を生成する。
  String codeChallenge(String codeVerifier) {
    final digest = sha256.convert(utf8.encode(codeVerifier));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// 認可リクエストの URI を組み立てる。
  Uri buildAuthorizeUri({
    required String codeChallenge,
    required String state,
  }) {
    return Uri.parse(SpotifyConstants.authorizeUrl).replace(
      queryParameters: <String, String>{
        'client_id': Env.spotifyClientId,
        'response_type': 'code',
        'redirect_uri': SpotifyConstants.redirectUri,
        'code_challenge_method': 'S256',
        'code_challenge': codeChallenge,
        'state': state,
        'scope': SpotifyConstants.scopeString,
      },
    );
  }

  /// 認可コードをトークンに交換する。
  Future<SpotifyAuth> exchangeCode({
    required String code,
    required String codeVerifier,
  }) {
    return _postToken(<String, String>{
      'client_id': Env.spotifyClientId,
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': SpotifyConstants.redirectUri,
      'code_verifier': codeVerifier,
    });
  }

  /// リフレッシュトークンでアクセストークンを更新する。
  Future<SpotifyAuth> refresh(String refreshToken) {
    return _postToken(<String, String>{
      'client_id': Env.spotifyClientId,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    }, fallbackRefreshToken: refreshToken);
  }

  Future<SpotifyAuth> _postToken(
    Map<String, String> body, {
    String? fallbackRefreshToken,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        SpotifyConstants.tokenUrl,
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final data = response.data ?? const <String, dynamic>{};
      final expiresIn = (data['expires_in'] as num?)?.toInt() ?? 3600;
      return SpotifyAuth(
        accessToken: data['access_token'] as String,
        refreshToken:
            (data['refresh_token'] as String?) ?? fallbackRefreshToken ?? '',
        expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      );
    } on DioException catch (e) {
      // トークン取得失敗は再認証が必要とみなす。
      final mapped = mapDioException(e, resource: '認証トークン');
      throw mapped is NetworkError ? mapped : const AppError.authExpired();
    }
  }
}
