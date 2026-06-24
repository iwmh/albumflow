// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ユーザーのプレイリスト一覧の ViewModel。

@ProviderFor(PlaylistsController)
final playlistsControllerProvider = PlaylistsControllerProvider._();

/// ユーザーのプレイリスト一覧の ViewModel。
final class PlaylistsControllerProvider
    extends $AsyncNotifierProvider<PlaylistsController, List<Playlist>> {
  /// ユーザーのプレイリスト一覧の ViewModel。
  PlaylistsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsControllerHash();

  @$internal
  @override
  PlaylistsController create() => PlaylistsController();
}

String _$playlistsControllerHash() =>
    r'0a6b358f3b6fffa4ed455d0755c9cf1fdffe0014';

/// ユーザーのプレイリスト一覧の ViewModel。

abstract class _$PlaylistsController extends $AsyncNotifier<List<Playlist>> {
  FutureOr<List<Playlist>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Playlist>>, List<Playlist>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Playlist>>, List<Playlist>>,
              AsyncValue<List<Playlist>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
