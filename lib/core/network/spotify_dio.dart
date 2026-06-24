import 'package:albumflow/core/config/spotify_constants.dart';
import 'package:albumflow/core/network/interceptors/auth_interceptor.dart';
import 'package:albumflow/core/network/interceptors/rate_limit_interceptor.dart';
import 'package:albumflow/core/network/interceptors/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spotify_dio.g.dart';

/// Spotify Web API への認証付き Dio クライアント。
///
/// インターセプターでトークン付与・401 リフレッシュ・429/5xx の再試行を一元化する。
@Riverpod(keepAlive: true)
Dio spotifyDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: SpotifyConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    ),
  );
  dio.interceptors.addAll(<Interceptor>[
    AuthInterceptor(ref, dio),
    RateLimitInterceptor(dio),
    RetryInterceptor(dio),
  ]);
  ref.onDispose(dio.close);
  return dio;
}
