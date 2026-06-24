/// Spotify Web API / OAuth 2.0 PKCE 関連の定数。
class SpotifyConstants {
  const SpotifyConstants._();

  /// Web API のベース URL。
  static const String apiBaseUrl = 'https://api.spotify.com/v1';

  /// 認可エンドポイント。
  static const String authorizeUrl = 'https://accounts.spotify.com/authorize';

  /// トークンエンドポイント。
  static const String tokenUrl = 'https://accounts.spotify.com/api/token';

  /// リダイレクト URI。Spotify Developer Dashboard に登録する値と完全一致させる。
  static const String redirectUri = 'albumflow://callback';

  /// 要求するスコープ。
  static const List<String> scopes = <String>[
    'playlist-read-private',
    'playlist-read-collaborative',
    'playlist-modify-public',
    'playlist-modify-private',
    'user-library-read',
    'user-library-modify',
    'user-read-private',
    'user-read-email',
  ];

  /// 認可リクエスト用にスペース区切りで結合したスコープ文字列。
  static String get scopeString => scopes.join(' ');

  /// 1 リクエストで追加できるトラックの最大数。
  static const int addTracksBatchSize = 100;
}
