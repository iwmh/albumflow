// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_extraction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(extractAlbumsUseCase)
final extractAlbumsUseCaseProvider = ExtractAlbumsUseCaseProvider._();

final class ExtractAlbumsUseCaseProvider
    extends
        $FunctionalProvider<
          ExtractAlbumsUseCase,
          ExtractAlbumsUseCase,
          ExtractAlbumsUseCase
        >
    with $Provider<ExtractAlbumsUseCase> {
  ExtractAlbumsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'extractAlbumsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$extractAlbumsUseCaseHash();

  @$internal
  @override
  $ProviderElement<ExtractAlbumsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExtractAlbumsUseCase create(Ref ref) {
    return extractAlbumsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExtractAlbumsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExtractAlbumsUseCase>(value),
    );
  }
}

String _$extractAlbumsUseCaseHash() =>
    r'733a1ef43956b84e23c6e263648a3af38c4736e6';

@ProviderFor(addAlbumToPlaylistUseCase)
final addAlbumToPlaylistUseCaseProvider = AddAlbumToPlaylistUseCaseProvider._();

final class AddAlbumToPlaylistUseCaseProvider
    extends
        $FunctionalProvider<
          AddAlbumToPlaylistUseCase,
          AddAlbumToPlaylistUseCase,
          AddAlbumToPlaylistUseCase
        >
    with $Provider<AddAlbumToPlaylistUseCase> {
  AddAlbumToPlaylistUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addAlbumToPlaylistUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addAlbumToPlaylistUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddAlbumToPlaylistUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddAlbumToPlaylistUseCase create(Ref ref) {
    return addAlbumToPlaylistUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddAlbumToPlaylistUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddAlbumToPlaylistUseCase>(value),
    );
  }
}

String _$addAlbumToPlaylistUseCaseHash() =>
    r'0ee7b3d8a1030e7fc2774621c94ad89825b47e64';
