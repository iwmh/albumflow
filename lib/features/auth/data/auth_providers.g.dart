// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'5f0f1e7075cbfc89c9f88bceffd63f21bf812b87';

@ProviderFor(secureTokenStorage)
final secureTokenStorageProvider = SecureTokenStorageProvider._();

final class SecureTokenStorageProvider
    extends
        $FunctionalProvider<
          SecureTokenStorage,
          SecureTokenStorage,
          SecureTokenStorage
        >
    with $Provider<SecureTokenStorage> {
  SecureTokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureTokenStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureTokenStorageHash();

  @$internal
  @override
  $ProviderElement<SecureTokenStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureTokenStorage create(Ref ref) {
    return secureTokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureTokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureTokenStorage>(value),
    );
  }
}

String _$secureTokenStorageHash() =>
    r'7fb5c5f1854480d2758a9d95a474d497178fa790';

@ProviderFor(spotifyAuthService)
final spotifyAuthServiceProvider = SpotifyAuthServiceProvider._();

final class SpotifyAuthServiceProvider
    extends
        $FunctionalProvider<
          SpotifyAuthService,
          SpotifyAuthService,
          SpotifyAuthService
        >
    with $Provider<SpotifyAuthService> {
  SpotifyAuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyAuthServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyAuthServiceHash();

  @$internal
  @override
  $ProviderElement<SpotifyAuthService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpotifyAuthService create(Ref ref) {
    return spotifyAuthService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotifyAuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotifyAuthService>(value),
    );
  }
}

String _$spotifyAuthServiceHash() =>
    r'da27ecfb5f5e26db449a8512c6ecd94293f5e386';

/// 認証リポジトリ。`tokenRepositoryProvider` の override 先でもある。

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// 認証リポジトリ。`tokenRepositoryProvider` の override 先でもある。

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// 認証リポジトリ。`tokenRepositoryProvider` の override 先でもある。
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'beb9c32af45b23b9aa883b4f62fdd7bc74996509';
