// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpotifyAuth {

 String get accessToken; String get refreshToken; DateTime get expiresAt;
/// Create a copy of SpotifyAuth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpotifyAuthCopyWith<SpotifyAuth> get copyWith => _$SpotifyAuthCopyWithImpl<SpotifyAuth>(this as SpotifyAuth, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpotifyAuth&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'SpotifyAuth(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $SpotifyAuthCopyWith<$Res>  {
  factory $SpotifyAuthCopyWith(SpotifyAuth value, $Res Function(SpotifyAuth) _then) = _$SpotifyAuthCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, DateTime expiresAt
});




}
/// @nodoc
class _$SpotifyAuthCopyWithImpl<$Res>
    implements $SpotifyAuthCopyWith<$Res> {
  _$SpotifyAuthCopyWithImpl(this._self, this._then);

  final SpotifyAuth _self;
  final $Res Function(SpotifyAuth) _then;

/// Create a copy of SpotifyAuth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SpotifyAuth].
extension SpotifyAuthPatterns on SpotifyAuth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpotifyAuth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpotifyAuth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpotifyAuth value)  $default,){
final _that = this;
switch (_that) {
case _SpotifyAuth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpotifyAuth value)?  $default,){
final _that = this;
switch (_that) {
case _SpotifyAuth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpotifyAuth() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _SpotifyAuth():
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _SpotifyAuth() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _SpotifyAuth extends SpotifyAuth {
  const _SpotifyAuth({required this.accessToken, required this.refreshToken, required this.expiresAt}): super._();
  

@override final  String accessToken;
@override final  String refreshToken;
@override final  DateTime expiresAt;

/// Create a copy of SpotifyAuth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpotifyAuthCopyWith<_SpotifyAuth> get copyWith => __$SpotifyAuthCopyWithImpl<_SpotifyAuth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpotifyAuth&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt);

@override
String toString() {
  return 'SpotifyAuth(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$SpotifyAuthCopyWith<$Res> implements $SpotifyAuthCopyWith<$Res> {
  factory _$SpotifyAuthCopyWith(_SpotifyAuth value, $Res Function(_SpotifyAuth) _then) = __$SpotifyAuthCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, DateTime expiresAt
});




}
/// @nodoc
class __$SpotifyAuthCopyWithImpl<$Res>
    implements _$SpotifyAuthCopyWith<$Res> {
  __$SpotifyAuthCopyWithImpl(this._self, this._then);

  final _SpotifyAuth _self;
  final $Res Function(_SpotifyAuth) _then;

/// Create a copy of SpotifyAuth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,}) {
  return _then(_SpotifyAuth(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
