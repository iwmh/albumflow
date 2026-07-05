import 'package:albumflow/l10n/generated/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// [AppError.notFound] が対象とするリソースの種類。
///
/// 表示名はロケール依存のため、名前ではなく種類のみをここで表現する。
enum ApiResource { playlist, track, album, authToken, generic }

/// アプリ全体で扱う型付きエラー。
///
/// 素の `throw Exception(...)` は使わず、必ずこの型に変換して扱う。
@freezed
sealed class AppError with _$AppError implements Exception {
  /// 認証の有効期限切れ・リフレッシュ失敗。再ログインが必要。
  const factory AppError.authExpired() = AuthExpiredError;

  /// ネットワーク到達不可・タイムアウトなど。
  const factory AppError.network({String? message}) = NetworkError;

  /// レート制限（HTTP 429）。`retryAfterSeconds` 秒後に再試行可能。
  const factory AppError.rateLimited({required int retryAfterSeconds}) =
      RateLimitedError;

  /// アクセス権限がない（HTTP 403）。他人のプレイリストの編集など。
  const factory AppError.forbidden({String? reason}) = ForbiddenError;

  /// サーバーエラー（HTTP 5xx）。
  const factory AppError.server({required int statusCode}) = ServerError;

  /// リソースが見つからない（HTTP 404）。
  const factory AppError.notFound({required ApiResource resource}) =
      NotFoundError;

  /// その他の予期しないエラー。
  const factory AppError.unknown({Object? cause}) = UnknownError;
}

/// ユーザー向けメッセージ。
extension AppErrorMessage on AppError {
  String displayMessage(AppLocalizations l10n) => switch (this) {
    AuthExpiredError() => l10n.authExpiredMessage,
    NetworkError(:final message) => l10n.networkErrorMessage(
      message ?? l10n.unknownNetworkErrorMessage,
    ),
    RateLimitedError(:final retryAfterSeconds) => l10n.rateLimitedMessage(
      retryAfterSeconds,
    ),
    ForbiddenError(:final reason) =>
      reason != null
          ? l10n.forbiddenMessageWithReason(reason)
          : l10n.forbiddenMessage,
    ServerError(:final statusCode) => l10n.serverErrorMessage(statusCode),
    NotFoundError(:final resource) => l10n.notFoundMessage(
      resource.label(l10n),
    ),
    UnknownError() => l10n.unknownErrorMessage,
  };
}

/// [ApiResource] のユーザー向け表示名。
extension ApiResourceLabel on ApiResource {
  String label(AppLocalizations l10n) => switch (this) {
    ApiResource.playlist => l10n.resourceLabelPlaylist,
    ApiResource.track => l10n.resourceLabelTrack,
    ApiResource.album => l10n.resourceLabelAlbum,
    ApiResource.authToken => l10n.resourceLabelAuthToken,
    ApiResource.generic => l10n.resourceLabelGeneric,
  };
}
