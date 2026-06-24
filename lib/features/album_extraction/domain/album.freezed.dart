// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Album {

 String get id; String get title; String get type; int get totalTracks; String get releaseDate; int get totalDurationMs; List<String> get artists; String? get imageUrl;
/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumCopyWith<Album> get copyWith => _$AlbumCopyWithImpl<Album>(this as Album, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Album&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalTracks, totalTracks) || other.totalTracks == totalTracks)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.totalDurationMs, totalDurationMs) || other.totalDurationMs == totalDurationMs)&&const DeepCollectionEquality().equals(other.artists, artists)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,type,totalTracks,releaseDate,totalDurationMs,const DeepCollectionEquality().hash(artists),imageUrl);

@override
String toString() {
  return 'Album(id: $id, title: $title, type: $type, totalTracks: $totalTracks, releaseDate: $releaseDate, totalDurationMs: $totalDurationMs, artists: $artists, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res>  {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) = _$AlbumCopyWithImpl;
@useResult
$Res call({
 String id, String title, String type, int totalTracks, String releaseDate, int totalDurationMs, List<String> artists, String? imageUrl
});




}
/// @nodoc
class _$AlbumCopyWithImpl<$Res>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? totalTracks = null,Object? releaseDate = null,Object? totalDurationMs = null,Object? artists = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,totalTracks: null == totalTracks ? _self.totalTracks : totalTracks // ignore: cast_nullable_to_non_nullable
as int,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String,totalDurationMs: null == totalDurationMs ? _self.totalDurationMs : totalDurationMs // ignore: cast_nullable_to_non_nullable
as int,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Album value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Album value)  $default,){
final _that = this;
switch (_that) {
case _Album():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Album value)?  $default,){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String type,  int totalTracks,  String releaseDate,  int totalDurationMs,  List<String> artists,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.totalTracks,_that.releaseDate,_that.totalDurationMs,_that.artists,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String type,  int totalTracks,  String releaseDate,  int totalDurationMs,  List<String> artists,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Album():
return $default(_that.id,_that.title,_that.type,_that.totalTracks,_that.releaseDate,_that.totalDurationMs,_that.artists,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String type,  int totalTracks,  String releaseDate,  int totalDurationMs,  List<String> artists,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.totalTracks,_that.releaseDate,_that.totalDurationMs,_that.artists,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Album extends Album {
  const _Album({required this.id, required this.title, required this.type, required this.totalTracks, required this.releaseDate, required this.totalDurationMs, required final  List<String> artists, this.imageUrl}): _artists = artists,super._();
  

@override final  String id;
@override final  String title;
@override final  String type;
@override final  int totalTracks;
@override final  String releaseDate;
@override final  int totalDurationMs;
 final  List<String> _artists;
@override List<String> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}

@override final  String? imageUrl;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumCopyWith<_Album> get copyWith => __$AlbumCopyWithImpl<_Album>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Album&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalTracks, totalTracks) || other.totalTracks == totalTracks)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.totalDurationMs, totalDurationMs) || other.totalDurationMs == totalDurationMs)&&const DeepCollectionEquality().equals(other._artists, _artists)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,type,totalTracks,releaseDate,totalDurationMs,const DeepCollectionEquality().hash(_artists),imageUrl);

@override
String toString() {
  return 'Album(id: $id, title: $title, type: $type, totalTracks: $totalTracks, releaseDate: $releaseDate, totalDurationMs: $totalDurationMs, artists: $artists, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) = __$AlbumCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String type, int totalTracks, String releaseDate, int totalDurationMs, List<String> artists, String? imageUrl
});




}
/// @nodoc
class __$AlbumCopyWithImpl<$Res>
    implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? totalTracks = null,Object? releaseDate = null,Object? totalDurationMs = null,Object? artists = null,Object? imageUrl = freezed,}) {
  return _then(_Album(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,totalTracks: null == totalTracks ? _self.totalTracks : totalTracks // ignore: cast_nullable_to_non_nullable
as int,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String,totalDurationMs: null == totalDurationMs ? _self.totalDurationMs : totalDurationMs // ignore: cast_nullable_to_non_nullable
as int,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
