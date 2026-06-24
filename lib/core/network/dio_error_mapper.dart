import 'package:albumflow/core/error/app_error.dart';
import 'package:dio/dio.dart';

/// `DioException` を型付きの [AppError] に変換する。
AppError mapDioException(DioException e, {String resource = 'リソース'}) {
  // インターセプター等で既に AppError が設定されている場合はそれを優先。
  if (e.error is AppError) return e.error! as AppError;

  final status = e.response?.statusCode;
  switch (status) {
    case 401:
      return const AppError.authExpired();
    case 404:
      return AppError.notFound(resource: resource);
    case 429:
      final header = e.response?.headers.value('retry-after');
      return AppError.rateLimited(
        retryAfterSeconds: int.tryParse(header ?? '') ?? 1,
      );
  }
  if (status != null && status >= 500) {
    return AppError.server(statusCode: status);
  }
  return AppError.network(message: e.message ?? '不明なネットワークエラー');
}
