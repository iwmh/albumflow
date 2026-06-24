// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_add_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アルバム × 登録先ごとのワンタップ登録を実行する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。

@ProviderFor(QuickAddController)
final quickAddControllerProvider = QuickAddControllerProvider._();

/// アルバム × 登録先ごとのワンタップ登録を実行する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。
final class QuickAddControllerProvider
    extends $NotifierProvider<QuickAddController, void> {
  /// アルバム × 登録先ごとのワンタップ登録を実行する ViewModel（Commands パターン）。
  ///
  /// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
  /// [Command0] を View が `ListenableBuilder` で監視して取得する。
  QuickAddControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickAddControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickAddControllerHash();

  @$internal
  @override
  QuickAddController create() => QuickAddController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$quickAddControllerHash() =>
    r'fd2b02eb88c6faa224ac72ae39b08e9a4cdce12b';

/// アルバム × 登録先ごとのワンタップ登録を実行する ViewModel（Commands パターン）。
///
/// 各組み合わせの実行中・成功・失敗の状態は、[commandFor] が返す
/// [Command0] を View が `ListenableBuilder` で監視して取得する。

abstract class _$QuickAddController extends $Notifier<void> {
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
