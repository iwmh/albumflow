// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_album_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アルバムをプレイリストから削除する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。

@ProviderFor(RemoveAlbumController)
final removeAlbumControllerProvider = RemoveAlbumControllerProvider._();

/// アルバムをプレイリストから削除する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。
final class RemoveAlbumControllerProvider
    extends $NotifierProvider<RemoveAlbumController, void> {
  /// アルバムをプレイリストから削除する ViewModel（Commands パターン）。
  ///
  /// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
  /// [Command0] を View が `ListenableBuilder` で監視して取得する。
  RemoveAlbumControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeAlbumControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeAlbumControllerHash();

  @$internal
  @override
  RemoveAlbumController create() => RemoveAlbumController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$removeAlbumControllerHash() =>
    r'378514018598e3384f54fff6ac4297d362b2181b';

/// アルバムをプレイリストから削除する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。

abstract class _$RemoveAlbumController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
