import 'dart:async';

import 'package:dio/dio.dart';

/// HTTP 429（レート制限）を受けたら `Retry-After` 秒だけ待機して 1 度再試行する。
class RateLimitInterceptor extends Interceptor {
  RateLimitInterceptor(this._dio);

  final Dio _dio;
  static const String _retriedKey = 'rate_limit_retried';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    if (err.response?.statusCode == 429 && !alreadyRetried) {
      final header = err.response?.headers.value('retry-after');
      final seconds = int.tryParse(header ?? '') ?? 1;
      await Future<void>.delayed(Duration(seconds: seconds));
      final options = err.requestOptions..extra[_retriedKey] = true;
      try {
        final response = await _dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }
    handler.next(err);
  }
}
