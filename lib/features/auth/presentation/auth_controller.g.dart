// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, SpotifyAuth?> {
  /// 認証状態の ViewModel。
  ///
  /// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'd224e8518b7dffc4667fa1a30232e2a43a90eae7';

/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。

abstract class _$AuthController extends $AsyncNotifier<SpotifyAuth?> {
  FutureOr<SpotifyAuth?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SpotifyAuth?>, SpotifyAuth?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotifyAuth?>, SpotifyAuth?>,
              AsyncValue<SpotifyAuth?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 認証済みかどうか（ルーティング用）。

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// 認証済みかどうか（ルーティング用）。

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 認証済みかどうか（ルーティング用）。
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'1dd646925b2cae24d844b34ad90bbeceea014015';
