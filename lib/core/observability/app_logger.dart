import 'package:flutter/foundation.dart';

/// 構造化ログの最小実装。
///
/// `print` は使わず常にこのロガー経由でログを出す（`avoid_print` 準拠）。
/// 本番では Crashlytics 等への転送をここに追加する。
class AppLogger {
  const AppLogger._();

  static void debug(String message) {
    if (kDebugMode) debugPrint('[DEBUG] $message');
  }

  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO] $message');
  }

  static void warning(String message) {
    debugPrint('[WARN] $message');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message${error != null ? ' : $error' : ''}');
    if (stackTrace != null) debugPrint(stackTrace.toString());
    // TODO(observability): Crashlytics.recordError(error, stackTrace) を追加。
  }
}
