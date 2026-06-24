// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlbumFilter {

 bool get includeSingles; bool get includeCompilations;
/// Create a copy of AlbumFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumFilterCopyWith<AlbumFilter> get copyWith => _$AlbumFilterCopyWithImpl<AlbumFilter>(this as AlbumFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumFilter&&(identical(other.includeSingles, includeSingles) || other.includeSingles == includeSingles)&&(identical(other.includeCompilations, includeCompilations) || other.includeCompilations == includeCompilations));
}


@override
int get hashCode => Object.hash(runtimeType,includeSingles,includeCompilations);

@override
String toString() {
  return 'AlbumFilter(includeSingles: $includeSingles, includeCompilations: $includeCompilations)';
}


}

/// @nodoc
abstract mixin class $AlbumFilterCopyWith<$Res>  {
  factory $AlbumFilterCopyWith(AlbumFilter value, $Res Function(AlbumFilter) _then) = _$AlbumFilterCopyWithImpl;
@useResult
$Res call({
 bool includeSingles, bool includeCompilations
});




}
/// @nodoc
class _$AlbumFilterCopyWithImpl<$Res>
    implements $AlbumFilterCopyWith<$Res> {
  _$AlbumFilterCopyWithImpl(this._self, this._then);

  final AlbumFilter _self;
  final $Res Function(AlbumFilter) _then;

/// Create a copy of AlbumFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? includeSingles = null,Object? includeCompilations = null,}) {
  return _then(_self.copyWith(
includeSingles: null == includeSingles ? _self.includeSingles : includeSingles // ignore: cast_nullable_to_non_nullable
as bool,includeCompilations: null == includeCompilations ? _self.includeCompilations : includeCompilations // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlbumFilter].
extension AlbumFilterPatterns on AlbumFilter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumFilter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumFilter value)  $default,){
final _that = this;
switch (_that) {
case _AlbumFilter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumFilter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool includeSingles,  bool includeCompilations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlbumFilter() when $default != null:
return $default(_that.includeSingles,_that.includeCompilations);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool includeSingles,  bool includeCompilations)  $default,) {final _that = this;
switch (_that) {
case _AlbumFilter():
return $default(_that.includeSingles,_that.includeCompilations);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool includeSingles,  bool includeCompilations)?  $default,) {final _that = this;
switch (_that) {
case _AlbumFilter() when $default != null:
return $default(_that.includeSingles,_that.includeCompilations);case _:
  return null;

}
}

}

/// @nodoc


class _AlbumFilter implements AlbumFilter {
  const _AlbumFilter({this.includeSingles = false, this.includeCompilations = true});
  

@override@JsonKey() final  bool includeSingles;
@override@JsonKey() final  bool includeCompilations;

/// Create a copy of AlbumFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumFilterCopyWith<_AlbumFilter> get copyWith => __$AlbumFilterCopyWithImpl<_AlbumFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumFilter&&(identical(other.includeSingles, includeSingles) || other.includeSingles == includeSingles)&&(identical(other.includeCompilations, includeCompilations) || other.includeCompilations == includeCompilations));
}


@override
int get hashCode => Object.hash(runtimeType,includeSingles,includeCompilations);

@override
String toString() {
  return 'AlbumFilter(includeSingles: $includeSingles, includeCompilations: $includeCompilations)';
}


}

/// @nodoc
abstract mixin class _$AlbumFilterCopyWith<$Res> implements $AlbumFilterCopyWith<$Res> {
  factory _$AlbumFilterCopyWith(_AlbumFilter value, $Res Function(_AlbumFilter) _then) = __$AlbumFilterCopyWithImpl;
@override @useResult
$Res call({
 bool includeSingles, bool includeCompilations
});




}
/// @nodoc
class __$AlbumFilterCopyWithImpl<$Res>
    implements _$AlbumFilterCopyWith<$Res> {
  __$AlbumFilterCopyWithImpl(this._self, this._then);

  final _AlbumFilter _self;
  final $Res Function(_AlbumFilter) _then;

/// Create a copy of AlbumFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? includeSingles = null,Object? includeCompilations = null,}) {
  return _then(_AlbumFilter(
includeSingles: null == includeSingles ? _self.includeSingles : includeSingles // ignore: cast_nullable_to_non_nullable
as bool,includeCompilations: null == includeCompilations ? _self.includeCompilations : includeCompilations // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
