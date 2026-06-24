// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_add_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アルバム × 登録先ごとの実行状態を保持する Command パターンの ViewModel。
///
/// 状態は `quickAddKey(albumId, targetId) -> QuickAddStatus` のマップ。

@ProviderFor(QuickAddController)
final quickAddControllerProvider = QuickAddControllerProvider._();

/// アルバム × 登録先ごとの実行状態を保持する Command パターンの ViewModel。
///
/// 状態は `quickAddKey(albumId, targetId) -> QuickAddStatus` のマップ。
final class QuickAddControllerProvider
    extends $NotifierProvider<QuickAddController, Map<String, QuickAddStatus>> {
  /// アルバム × 登録先ごとの実行状態を保持する Command パターンの ViewModel。
  ///
  /// 状態は `quickAddKey(albumId, targetId) -> QuickAddStatus` のマップ。
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
  Override overrideWithValue(Map<String, QuickAddStatus> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, QuickAddStatus>>(value),
    );
  }
}

String _$quickAddControllerHash() =>
    r'2da1a49721c80f4981a9a21d2ad3e4f5b4af8c78';

/// アルバム × 登録先ごとの実行状態を保持する Command パターンの ViewModel。
///
/// 状態は `quickAddKey(albumId, targetId) -> QuickAddStatus` のマップ。

abstract class _$QuickAddController
    extends $Notifier<Map<String, QuickAddStatus>> {
  Map<String, QuickAddStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, QuickAddStatus>, Map<String, QuickAddStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, QuickAddStatus>,
                Map<String, QuickAddStatus>
              >,
              Map<String, QuickAddStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
