// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Track {

 String get id; String get name; List<String> get artists; String get albumId; String get albumName; String get albumType; int get albumTotalTracks; String get albumReleaseDate; int get durationMs; String get uri; String? get albumImageUrl;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.artists, artists)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.albumType, albumType) || other.albumType == albumType)&&(identical(other.albumTotalTracks, albumTotalTracks) || other.albumTotalTracks == albumTotalTracks)&&(identical(other.albumReleaseDate, albumReleaseDate) || other.albumReleaseDate == albumReleaseDate)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.albumImageUrl, albumImageUrl) || other.albumImageUrl == albumImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(artists),albumId,albumName,albumType,albumTotalTracks,albumReleaseDate,durationMs,uri,albumImageUrl);

@override
String toString() {
  return 'Track(id: $id, name: $name, artists: $artists, albumId: $albumId, albumName: $albumName, albumType: $albumType, albumTotalTracks: $albumTotalTracks, albumReleaseDate: $albumReleaseDate, durationMs: $durationMs, uri: $uri, albumImageUrl: $albumImageUrl)';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> artists, String albumId, String albumName, String albumType, int albumTotalTracks, String albumReleaseDate, int durationMs, String uri, String? albumImageUrl
});




}
/// @nodoc
class _$TrackCopyWithImpl<$Res>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._self, this._then);

  final Track _self;
  final $Res Function(Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? artists = null,Object? albumId = null,Object? albumName = null,Object? albumType = null,Object? albumTotalTracks = null,Object? albumReleaseDate = null,Object? durationMs = null,Object? uri = null,Object? albumImageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<String>,albumId: null == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String,albumName: null == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String,albumType: null == albumType ? _self.albumType : albumType // ignore: cast_nullable_to_non_nullable
as String,albumTotalTracks: null == albumTotalTracks ? _self.albumTotalTracks : albumTotalTracks // ignore: cast_nullable_to_non_nullable
as int,albumReleaseDate: null == albumReleaseDate ? _self.albumReleaseDate : albumReleaseDate // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,albumImageUrl: freezed == albumImageUrl ? _self.albumImageUrl : albumImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Track].
extension TrackPatterns on Track {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Track value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Track value)  $default,){
final _that = this;
switch (_that) {
case _Track():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Track value)?  $default,){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> artists,  String albumId,  String albumName,  String albumType,  int albumTotalTracks,  String albumReleaseDate,  int durationMs,  String uri,  String? albumImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.name,_that.artists,_that.albumId,_that.albumName,_that.albumType,_that.albumTotalTracks,_that.albumReleaseDate,_that.durationMs,_that.uri,_that.albumImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> artists,  String albumId,  String albumName,  String albumType,  int albumTotalTracks,  String albumReleaseDate,  int durationMs,  String uri,  String? albumImageUrl)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.id,_that.name,_that.artists,_that.albumId,_that.albumName,_that.albumType,_that.albumTotalTracks,_that.albumReleaseDate,_that.durationMs,_that.uri,_that.albumImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> artists,  String albumId,  String albumName,  String albumType,  int albumTotalTracks,  String albumReleaseDate,  int durationMs,  String uri,  String? albumImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.id,_that.name,_that.artists,_that.albumId,_that.albumName,_that.albumType,_that.albumTotalTracks,_that.albumReleaseDate,_that.durationMs,_that.uri,_that.albumImageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Track extends Track {
  const _Track({required this.id, required this.name, required final  List<String> artists, required this.albumId, required this.albumName, required this.albumType, required this.albumTotalTracks, required this.albumReleaseDate, required this.durationMs, required this.uri, this.albumImageUrl}): _artists = artists,super._();
  

@override final  String id;
@override final  String name;
 final  List<String> _artists;
@override List<String> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}

@override final  String albumId;
@override final  String albumName;
@override final  String albumType;
@override final  int albumTotalTracks;
@override final  String albumReleaseDate;
@override final  int durationMs;
@override final  String uri;
@override final  String? albumImageUrl;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._artists, _artists)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.albumType, albumType) || other.albumType == albumType)&&(identical(other.albumTotalTracks, albumTotalTracks) || other.albumTotalTracks == albumTotalTracks)&&(identical(other.albumReleaseDate, albumReleaseDate) || other.albumReleaseDate == albumReleaseDate)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.albumImageUrl, albumImageUrl) || other.albumImageUrl == albumImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_artists),albumId,albumName,albumType,albumTotalTracks,albumReleaseDate,durationMs,uri,albumImageUrl);

@override
String toString() {
  return 'Track(id: $id, name: $name, artists: $artists, albumId: $albumId, albumName: $albumName, albumType: $albumType, albumTotalTracks: $albumTotalTracks, albumReleaseDate: $albumReleaseDate, durationMs: $durationMs, uri: $uri, albumImageUrl: $albumImageUrl)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> artists, String albumId, String albumName, String albumType, int albumTotalTracks, String albumReleaseDate, int durationMs, String uri, String? albumImageUrl
});




}
/// @nodoc
class __$TrackCopyWithImpl<$Res>
    implements _$TrackCopyWith<$Res> {
  __$TrackCopyWithImpl(this._self, this._then);

  final _Track _self;
  final $Res Function(_Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? artists = null,Object? albumId = null,Object? albumName = null,Object? albumType = null,Object? albumTotalTracks = null,Object? albumReleaseDate = null,Object? durationMs = null,Object? uri = null,Object? albumImageUrl = freezed,}) {
  return _then(_Track(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<String>,albumId: null == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String,albumName: null == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String,albumType: null == albumType ? _self.albumType : albumType // ignore: cast_nullable_to_non_nullable
as String,albumTotalTracks: null == albumTotalTracks ? _self.albumTotalTracks : albumTotalTracks // ignore: cast_nullable_to_non_nullable
as int,albumReleaseDate: null == albumReleaseDate ? _self.albumReleaseDate : albumReleaseDate // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,albumImageUrl: freezed == albumImageUrl ? _self.albumImageUrl : albumImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
