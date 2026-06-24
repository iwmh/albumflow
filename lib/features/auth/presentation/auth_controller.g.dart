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
/// ログイン・ログアウトの実行状態は [loginCommand] / [logoutCommand]
/// （Commands パターン）で公開する。

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
/// ログイン・ログアウトの実行状態は [loginCommand] / [logoutCommand]
/// （Commands パターン）で公開する。
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, SpotifyAuth?> {
  /// 認証状態の ViewModel。
  ///
  /// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
  /// ログイン・ログアウトの実行状態は [loginCommand] / [logoutCommand]
  /// （Commands パターン）で公開する。
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

String _$authControllerHash() => r'20b854460f2b8dc632cfc34b8917061a645cd086';

/// 認証状態の ViewModel。
///
/// 状態は `AsyncValue<SpotifyAuth?>`（`null` = 未ログイン）。
/// ログイン・ログアウトの実行状態は [loginCommand] / [logoutCommand]
/// （Commands パターン）で公開する。

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

String _$isAuthenticatedHash() => r'04e26ab9121c01373a46f077ec7c6e8d8fd8337a';
