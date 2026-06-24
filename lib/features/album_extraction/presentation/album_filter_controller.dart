import 'package:albumflow/features/album_extraction/domain/album_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_filter_controller.g.dart';

/// アルバム抽出フィルタの ViewModel。
@riverpod
class AlbumFilterController extends _$AlbumFilterController {
  @override
  AlbumFilter build() => const AlbumFilter();

  void toggleSingles() =>
      state = state.copyWith(includeSingles: !state.includeSingles);

  void toggleCompilations() =>
      state = state.copyWith(includeCompilations: !state.includeCompilations);
}
