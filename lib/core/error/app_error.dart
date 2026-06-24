import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// アプリ全体で扱う型付きエラー。
///
/// 素の `throw Exception(...)` は使わず、必ずこの型に変換して扱う。
@freezed
sealed class AppError with _$AppError implements Exception {
  /// 認証の有効期限切れ・リフレッシュ失敗。再ログインが必要。
  const factory AppError.authExpired() = AuthExpiredError;

  /// ネットワーク到達不可・タイムアウトなど。
  const factory AppError.network({required String message}) = NetworkError;

  /// レート制限（HTTP 429）。`retryAfterSeconds` 秒後に再試行可能。
  const factory AppError.rateLimited({required int retryAfterSeconds}) =
      RateLimitedError;

  /// サーバーエラー（HTTP 5xx）。
  const factory AppError.server({required int statusCode}) = ServerError;

  /// リソースが見つからない（HTTP 404）。
  const factory AppError.notFound({required String resource}) = NotFoundError;

  /// その他の予期しないエラー。
  const factory AppError.unknown({Object? cause}) = UnknownError;
}

/// ユーザー向けメッセージ。
extension AppErrorMessage on AppError {
  String get displayMessage => switch (this) {
    AuthExpiredError() => 'セッションの有効期限が切れました。再度ログインしてください。',
    NetworkError(:final message) => 'ネットワークエラーが発生しました（$message）。',
    RateLimitedError(:final retryAfterSeconds) =>
      'リクエストが多すぎます。$retryAfterSeconds 秒後に再試行してください。',
    ServerError(:final statusCode) => 'サーバーエラー（$statusCode）が発生しました。',
    NotFoundError(:final resource) => '$resource が見つかりませんでした。',
    UnknownError() => '予期しないエラーが発生しました。',
  };
}
