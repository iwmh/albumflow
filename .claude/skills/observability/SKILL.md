---
name: observability
description: Firebase Crashlytics・Firebase Performance・構造化ログによる本番アプリの観測可能性。クラッシュの早期検出、パフォーマンス監視、適切なログレベル管理を実装する。
---

# 観測可能性（Observability）

## 概要
`debugPrint`だけに頼った現状から、本番環境で問題を早期発見できる観測可能性スタックを構築する。

## パッケージ

```yaml
dependencies:
  firebase_core: ^3.13.0
  firebase_crashlytics: ^4.3.5
  firebase_performance: ^0.10.1+2
  flutter_riverpod: ^2.6.1  # 既存

dev_dependencies:
  # ローカル開発用
```

## 構造化ロガー

```dart
// lib/shared/logging/app_logger.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) debugPrint('[DEBUG] $message');
  }

  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO] $message');
    FirebaseCrashlytics.instance.log(message);
  }

  static void warning(String message, {Object? error}) {
    debugPrint('[WARN] $message${error != null ? ': $error' : ''}');
    FirebaseCrashlytics.instance.log('WARN: $message');
  }

  static void error(
    String message, {
    required Object error,
    StackTrace? stackTrace,
  }) {
    debugPrint('[ERROR] $message: $error');
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: message,
    );
  }
}
```

## main.dart のセットアップ

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // 未キャッチの Flutter エラーを Crashlytics へ
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Dart の未キャッチエラーを Crashlytics へ
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(child: AlbumFlowApp()));
}
```

## Firebase Performance（ネットワーク遅延計測）

```dart
// lib/shared/network/performance_interceptor.dart
class PerformanceInterceptor extends Interceptor {
  final _traces = <String, HttpMetric>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      final metric = FirebasePerformance.instance.newHttpMetric(
        '${options.baseUrl}${options.path}',
        HttpMethod.values.firstWhere(
          (m) => m.name.toLowerCase() == options.method.toLowerCase(),
          orElse: () => HttpMethod.Get,
        ),
      );
      metric.start();
      _traces[options.path] = metric;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _traces.remove(response.requestOptions.path)
      ?..httpResponseCode = response.statusCode
      ..stop();
    handler.next(response);
  }
}
```

## Riverpod エラー監視

```dart
// lib/shared/providers/provider_observer.dart
class CrashlyticsProviderObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.error(
      'Provider ${provider.name ?? provider.runtimeType} failed',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

// main.dart
runApp(
  ProviderScope(
    observers: [CrashlyticsProviderObserver()],
    child: const AlbumFlowApp(),
  ),
);
```

## ユーザー属性の設定

```dart
// ログイン成功時
FirebaseCrashlytics.instance.setUserIdentifier(userId);
FirebaseCrashlytics.instance.setCustomKey('app_version', packageInfo.version);
```

## このプロジェクトの移行

### `debugPrint` を AppLogger に置き換える箇所

| ファイル | 現状 | 修正後 |
|---|---|---|
| `auth_service.dart` | `debugPrint('OAuth error: $error')` | `AppLogger.warning('OAuth error', error: error)` |
| `auth_service.dart` | `debugPrint('Failed to get initial link: $e')` | `AppLogger.error('Deep link error', error: e)` |
| `main.dart` | `debugPrint('Deep link error: $err')` | `AppLogger.error('Deep link stream error', error: err)` |

## ローカル開発での Crashlytics 無効化

```dart
// lib/shared/logging/app_logger.dart
static bool get _isCrashlyticsEnabled =>
    !kDebugMode && Firebase.apps.isNotEmpty;
```

## アラート設定（Firebase Console）

- クラッシュフリーユーザー率 < 99% でアラート
- ANR（Application Not Responding）発生でアラート
- 特定エラーの急増でアラート

## リファレンス
- [Firebase Crashlytics for Flutter](https://firebase.flutter.dev/docs/crashlytics/overview)
- [Firebase Performance for Flutter](https://firebase.flutter.dev/docs/performance/overview)
