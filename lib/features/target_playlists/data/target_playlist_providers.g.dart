// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_playlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferencesAsync,
          SharedPreferencesAsync,
          SharedPreferencesAsync
        >
    with $Provider<SharedPreferencesAsync> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesAsync> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferencesAsync create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesAsync value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesAsync>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'4e2baac92647a5914c46b38ec3c662805cada4cb';

@ProviderFor(targetPlaylistRepository)
final targetPlaylistRepositoryProvider = TargetPlaylistRepositoryProvider._();

final class TargetPlaylistRepositoryProvider
    extends
        $FunctionalProvider<
          TargetPlaylistRepository,
          TargetPlaylistRepository,
          TargetPlaylistRepository
        >
    with $Provider<TargetPlaylistRepository> {
  TargetPlaylistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'targetPlaylistRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$targetPlaylistRepositoryHash();

  @$internal
  @override
  $ProviderElement<TargetPlaylistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TargetPlaylistRepository create(Ref ref) {
    return targetPlaylistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TargetPlaylistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TargetPlaylistRepository>(value),
    );
  }
}

String _$targetPlaylistRepositoryHash() =>
    r'1acd8f5360f85220ca22e609364b59fbb0584ced';
