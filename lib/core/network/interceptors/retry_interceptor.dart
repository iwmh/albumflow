import 'dart:async';

import 'package:dio/dio.dart';

/// HTTP 5xx を指数バックオフで最大 [maxRetries] 回まで再試行する。
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {this.maxRetries = 2});

  final Dio _dio;
  final int maxRetries;
  static const String _countKey = 'retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final isServerError = status != null && status >= 500;
    final count = (err.requestOptions.extra[_countKey] as int?) ?? 0;

    if (isServerError && count < maxRetries) {
      final delay = Duration(milliseconds: 300 * (1 << count));
      await Future<void>.delayed(delay);
      final options = err.requestOptions..extra[_countKey] = count + 1;
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
