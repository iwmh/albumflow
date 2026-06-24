/// ビルド時に `--dart-define` で注入される環境値。
///
/// 例: `flutter run --dart-define=SPOTIFY_CLIENT_ID=xxxxxxxx`
/// あるいは `--dart-define-from-file=env.json`（`env.json` は `.gitignore` 対象）。
///
/// 秘密情報をソースコードにハードコードしないために使用する。
class Env {
  const Env._();

  /// Spotify アプリの Client ID。
  static const String spotifyClientId = String.fromEnvironment(
    'SPOTIFY_CLIENT_ID',
  );

  /// Client ID が注入されているか。未設定なら認証画面で警告を表示する。
  static bool get hasSpotifyClientId => spotifyClientId.isNotEmpty;
}
