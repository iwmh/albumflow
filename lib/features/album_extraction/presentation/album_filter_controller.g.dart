// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アルバム抽出フィルタの ViewModel。

@ProviderFor(AlbumFilterController)
final albumFilterControllerProvider = AlbumFilterControllerProvider._();

/// アルバム抽出フィルタの ViewModel。
final class AlbumFilterControllerProvider
    extends $NotifierProvider<AlbumFilterController, AlbumFilter> {
  /// アルバム抽出フィルタの ViewModel。
  AlbumFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumFilterControllerHash();

  @$internal
  @override
  AlbumFilterController create() => AlbumFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumFilter>(value),
    );
  }
}

String _$albumFilterControllerHash() =>
    r'1e982ff7791d54bdd1e396e86f4692958aabae68';

/// アルバム抽出フィルタの ViewModel。

abstract class _$AlbumFilterController extends $Notifier<AlbumFilter> {
  AlbumFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AlbumFilter, AlbumFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumFilter, AlbumFilter>,
              AlbumFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
