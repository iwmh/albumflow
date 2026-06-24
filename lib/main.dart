import 'package:albumflow/app.dart';
import 'package:albumflow/core/network/token_repository.dart';
import 'package:albumflow/features/auth/data/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(firebase): FlutterFire 設定後に Firebase / Crashlytics を初期化する。
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(
    ProviderScope(
      overrides: [
        // core 層の TokenRepository に auth 層の実装を注入する。
        tokenRepositoryProvider.overrideWith(
          (ref) => ref.watch(authRepositoryProvider),
        ),
      ],
      child: const AlbumFlowApp(),
    ),
  );
}
