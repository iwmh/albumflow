// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 登録先プレイリスト設定の ViewModel（ID 集合）。
///
/// ON/OFF の切り替えは [toggleCommand]（Commands パターン）で公開する。

@ProviderFor(TargetSettingsController)
final targetSettingsControllerProvider = TargetSettingsControllerProvider._();

/// 登録先プレイリスト設定の ViewModel（ID 集合）。
///
/// ON/OFF の切り替えは [toggleCommand]（Commands パターン）で公開する。
final class TargetSettingsControllerProvider
    extends $AsyncNotifierProvider<TargetSettingsController, Set<String>> {
  /// 登録先プレイリスト設定の ViewModel（ID 集合）。
  ///
  /// ON/OFF の切り替えは [toggleCommand]（Commands パターン）で公開する。
  TargetSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'targetSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$targetSettingsControllerHash();

  @$internal
  @override
  TargetSettingsController create() => TargetSettingsController();
}

String _$targetSettingsControllerHash() =>
    r'a10b01ced26095f01d2f79c88c56d7cfb6a7fe4d';

/// 登録先プレイリスト設定の ViewModel（ID 集合）。
///
/// ON/OFF の切り替えは [toggleCommand]（Commands パターン）で公開する。

abstract class _$TargetSettingsController extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
