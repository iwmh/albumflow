// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_albums_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// プレイリストのトラックを取得（ネットワーク）。フィルタ変更では再取得しないようキャッシュする。

@ProviderFor(playlistTracks)
final playlistTracksProvider = PlaylistTracksFamily._();

/// プレイリストのトラックを取得（ネットワーク）。フィルタ変更では再取得しないようキャッシュする。

final class PlaylistTracksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Track>>,
          List<Track>,
          FutureOr<List<Track>>
        >
    with $FutureModifier<List<Track>>, $FutureProvider<List<Track>> {
  /// プレイリストのトラックを取得（ネットワーク）。フィルタ変更では再取得しないようキャッシュする。
  PlaylistTracksProvider._({
    required PlaylistTracksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playlistTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistTracksHash();

  @override
  String toString() {
    return r'playlistTracksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Track>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Track>> create(Ref ref) {
    final argument = this.argument as String;
    return playlistTracks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistTracksHash() => r'144bffc354de9396ae3b036794cbfb6a5bb46440';

/// プレイリストのトラックを取得（ネットワーク）。フィルタ変更では再取得しないようキャッシュする。

final class PlaylistTracksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Track>>, String> {
  PlaylistTracksFamily._()
    : super(
        retry: null,
        name: r'playlistTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// プレイリストのトラックを取得（ネットワーク）。フィルタ変更では再取得しないようキャッシュする。

  PlaylistTracksProvider call(String playlistId) =>
      PlaylistTracksProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistTracksProvider';
}

/// キャッシュ済みトラックから、フィルタを適用したアルバム一覧を導出する。

@ProviderFor(playlistAlbums)
final playlistAlbumsProvider = PlaylistAlbumsFamily._();

/// キャッシュ済みトラックから、フィルタを適用したアルバム一覧を導出する。

final class PlaylistAlbumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Album>>,
          List<Album>,
          FutureOr<List<Album>>
        >
    with $FutureModifier<List<Album>>, $FutureProvider<List<Album>> {
  /// キャッシュ済みトラックから、フィルタを適用したアルバム一覧を導出する。
  PlaylistAlbumsProvider._({
    required PlaylistAlbumsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playlistAlbumsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playlistAlbumsHash();

  @override
  String toString() {
    return r'playlistAlbumsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Album>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Album>> create(Ref ref) {
    final argument = this.argument as String;
    return playlistAlbums(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistAlbumsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistAlbumsHash() => r'85ecce0f0187109eb589ac1011558b378db70fbd';

/// キャッシュ済みトラックから、フィルタを適用したアルバム一覧を導出する。

final class PlaylistAlbumsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Album>>, String> {
  PlaylistAlbumsFamily._()
    : super(
        retry: null,
        name: r'playlistAlbumsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// キャッシュ済みトラックから、フィルタを適用したアルバム一覧を導出する。

  PlaylistAlbumsProvider call(String playlistId) =>
      PlaylistAlbumsProvider._(argument: playlistId, from: this);

  @override
  String toString() => r'playlistAlbumsProvider';
}
