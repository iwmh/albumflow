import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_filter.freezed.dart';

/// アルバム抽出のフィルタ条件（不変）。
///
/// 既定ではシングルを除外し、アルバム・EP・コンピレーションを表示する。
@freezed
abstract class AlbumFilter with _$AlbumFilter {
  const factory AlbumFilter({
    @Default(false) bool includeSingles,
    @Default(true) bool includeCompilations,
  }) = _AlbumFilter;
}
