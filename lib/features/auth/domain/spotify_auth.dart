import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_auth.freezed.dart';

/// Spotify OAuth のトークン情報（不変）。
@freezed
abstract class SpotifyAuth with _$SpotifyAuth {
  const factory SpotifyAuth({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _SpotifyAuth;

  const SpotifyAuth._();

  /// すでに期限切れか。
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 期限の 60 秒前を過ぎたか（余裕を持って事前リフレッシュするため）。
  bool get isExpiringSoon =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(seconds: 60)));
}
