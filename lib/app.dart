import 'dart:async';

import 'package:albumflow/core/observability/app_logger.dart';
import 'package:albumflow/core/router/app_router.dart';
import 'package:albumflow/core/theme/app_theme.dart';
import 'package:albumflow/features/auth/presentation/auth_controller.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アプリのルート Widget。
///
/// OAuth コールバック（`albumflow://callback`）のディープリンクを購読し、
/// 認可コードを受け取ってログインを完了させる。
class AlbumFlowApp extends ConsumerStatefulWidget {
  const AlbumFlowApp({super.key});

  @override
  ConsumerState<AlbumFlowApp> createState() => _AlbumFlowAppState();
}

class _AlbumFlowAppState extends ConsumerState<AlbumFlowApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (Object error) => AppLogger.warning('deep link error: $error'),
    );
  }

  void _handleUri(Uri uri) {
    final code = uri.queryParameters['code'];
    final returnedState = uri.queryParameters['state'];
    if (code != null && returnedState != null) {
      unawaited(
        ref
            .read(authControllerProvider.notifier)
            .completeLogin(code: code, returnedState: returnedState),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_linkSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'AlbumFlow for Spotify',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
