// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_target_playlists_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 登録先に設定されたプレイリストを、名前付きの [Playlist] として導出する。

@ProviderFor(selectedTargetPlaylists)
final selectedTargetPlaylistsProvider = SelectedTargetPlaylistsProvider._();

/// 登録先に設定されたプレイリストを、名前付きの [Playlist] として導出する。

final class SelectedTargetPlaylistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Playlist>>,
          List<Playlist>,
          FutureOr<List<Playlist>>
        >
    with $FutureModifier<List<Playlist>>, $FutureProvider<List<Playlist>> {
  /// 登録先に設定されたプレイリストを、名前付きの [Playlist] として導出する。
  SelectedTargetPlaylistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTargetPlaylistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTargetPlaylistsHash();

  @$internal
  @override
  $FutureProviderElement<List<Playlist>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Playlist>> create(Ref ref) {
    return selectedTargetPlaylists(ref);
  }
}

String _$selectedTargetPlaylistsHash() =>
    r'50177c80ce7bacf938c248b41d9ef86840343912';
