import 'package:albumflow/core/error/app_error.dart';
import 'package:albumflow/core/network/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 全リクエストに `Authorization: Bearer` を付与し、
/// 401 のときは 1 度だけトークンを更新して再試行する。
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref, this._dio);

  final Ref _ref;
  final Dio _dio;
  static const String _retriedKey = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _ref.read(tokenRepositoryProvider).validAccessToken();
      options.headers['Authorization'] = 'Bearer $token';
    } on AppError {
      // トークン取得に失敗してもリクエストは続行し、401 として処理させる。
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    if (err.response?.statusCode == 401 && !alreadyRetried) {
      try {
        final token = await _ref.read(tokenRepositoryProvider).refresh();
        final options = err.requestOptions
          ..extra[_retriedKey] = true
          ..headers['Authorization'] = 'Bearer $token';
        final response = await _dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } on AppError {
        await _ref.read(tokenRepositoryProvider).clear();
      }
    }
    handler.next(err);
  }
}
