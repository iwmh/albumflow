// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_dio.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spotify Web API への認証付き Dio クライアント。
///
/// インターセプターでトークン付与・401 リフレッシュ・429/5xx の再試行を一元化する。

@ProviderFor(spotifyDio)
final spotifyDioProvider = SpotifyDioProvider._();

/// Spotify Web API への認証付き Dio クライアント。
///
/// インターセプターでトークン付与・401 リフレッシュ・429/5xx の再試行を一元化する。

final class SpotifyDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Spotify Web API への認証付き Dio クライアント。
  ///
  /// インターセプターでトークン付与・401 リフレッシュ・429/5xx の再試行を一元化する。
  SpotifyDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return spotifyDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$spotifyDioHash() => r'17a5988f7903f7a94eb6b5ec4f94dbe41560c6c8';
