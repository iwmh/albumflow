---
name: network-layer
description: dioとInterceptorによるSpotify API通信の一元管理。認証トークン自動付与・401時の自動リフレッシュ・リトライ・レート制限ハンドリングの保守・拡張。
---

# ネットワーク層（dio + Interceptor）

## 概要
`core/network/spotify_dio.dart` に Dio クライアントを実装済みで、`AuthInterceptor`（トークン付与・401 リフレッシュ）・`RateLimitInterceptor`（429）・`RetryInterceptor`（5xx）で横断的関心事を一元化している。本スキルはこの構成の理解・保守・拡張（新エンドポイント追加やエラー変換の調整）に使う。`mapDioException` で `DioException → AppError` 変換、`fetchAllItems` でページネーションを行う。

## パッケージ追加

```yaml
dependencies:
  dio: ^5.8.0+1
  # リトライはdio_smart_retryまたは自前実装
```

## SpotifyHttpClient

```dart
// lib/shared/network/spotify_http_client.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spotify_http_client.g.dart';

@riverpod
Dio spotifyHttpClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.spotify.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(ref),
    RateLimitInterceptor(),
    RetryInterceptor(dio),
    LoggingInterceptor(),
  ]);

  return dio;
}
```

## AuthInterceptor（トークン自動付与 + 401自動リフレッシュ）

```dart
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);

  final Ref _ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final auth = await _ref.read(authRepositoryProvider).getStoredAuth();
    if (auth != null) {
      if (auth.isExpired) {
        try {
          final refreshed = await _ref
              .read(authRepositoryProvider)
              .refreshToken(auth.refreshToken);
          options.headers['Authorization'] = 'Bearer ${refreshed.accessToken}';
        } catch (_) {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.unknown,
              error: const AuthExpiredError(),
            ),
          );
        }
      } else {
        options.headers['Authorization'] = 'Bearer ${auth.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // トークンを無効化してログアウト
      await _ref.read(authRepositoryProvider).logout();
      _ref.invalidate(authProvider);
    }
    handler.next(err);
  }
}
```

## RateLimitInterceptor（429対応）

```dart
class RateLimitInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 429) {
      final retryAfter = int.tryParse(
        err.response?.headers.value('retry-after') ?? '1',
      ) ?? 1;
      await Future<void>.delayed(Duration(seconds: retryAfter));
      // リクエストを再試行
      try {
        final response = await Dio().fetch<dynamic>(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}
```

## RetryInterceptor（5xx エラー対応）

```dart
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);

  final Dio _dio;
  static const _maxRetries = 3;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode ?? 0;
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (_shouldRetry(statusCode) && retryCount < _maxRetries) {
      final delay = Duration(milliseconds: 500 * (retryCount + 1));
      await Future<void>.delayed(delay);

      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(int statusCode) =>
      statusCode >= 500 || statusCode == 0;
}
```

## エラー型への変換

```dart
// lib/shared/network/spotify_error.dart
sealed class SpotifyError {
  const SpotifyError();
}

class AuthExpiredError extends SpotifyError {
  const AuthExpiredError();
}

class RateLimitError extends SpotifyError {
  const RateLimitError({required this.retryAfterSeconds});
  final int retryAfterSeconds;
}

class NetworkError extends SpotifyError {
  const NetworkError({required this.message});
  final String message;
}

class ServerError extends SpotifyError {
  const ServerError({required this.statusCode});
  final int statusCode;
}
```

## ページネーションユーティリティ

```dart
// lib/shared/network/pagination.dart
extension SpotifyPagination on Dio {
  Future<List<T>> fetchAllPages<T>({
    required String initialUrl,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final results = <T>[];
    String? nextUrl = initialUrl;

    while (nextUrl != null) {
      final response = await get<Map<String, dynamic>>(nextUrl);
      final data = response.data!;
      results.addAll(
        (data['items'] as List)
            .whereType<Map<String, dynamic>>()
            .map(fromJson),
      );
      nextUrl = data['next'] as String?;
    }

    return results;
  }
}
```

## 使用例（Repository内）

```dart
class SpotifyPlaylistRepository implements PlaylistRepository {
  SpotifyPlaylistRepository(this._client);
  final Dio _client;

  @override
  Future<List<Playlist>> getPlaylists(String accessToken) =>
      _client.fetchAllPages(
        initialUrl: '/me/playlists?limit=50',
        fromJson: Playlist.fromJson,
      );
}
```

## よくある落とし穴
- ❌ `dio`インスタンスを毎回`new`する（Interceptorが効かない）
- ❌ Interceptorでエラーを握りつぶす（`handler.next(err)`を忘れる）
- ❌ レート制限の`Retry-After`ヘッダーを無視する
- ✅ `BaseOptions.baseUrl`を設定すればパスのみでOK

## リファレンス
- [dio pub.dev](https://pub.dev/packages/dio)
- [Spotify Rate Limits](https://developer.spotify.com/documentation/web-api/concepts/rate-limits)
