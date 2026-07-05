// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get playlistsScreenTitle => 'プレイリスト';

  @override
  String get targetSettingsTooltip => '登録先の設定';

  @override
  String get logoutTooltip => 'ログアウト';

  @override
  String get noPlaylistsMessage => 'プレイリストがありません';

  @override
  String get albumsScreenFallbackTitle => 'アルバム・EP';

  @override
  String get includeSinglesLabel => 'シングルも表示';

  @override
  String get noAlbumsMessage => 'アルバム・EP がありません';

  @override
  String get targetSettingsScreenTitle => '登録先プレイリストの設定';

  @override
  String get targetSettingsDescription => 'チェックしたプレイリストが、アルバムのワンタップ登録先になります。';

  @override
  String trackCount(int count) {
    return '$count 曲';
  }

  @override
  String get appTagline => 'プレイリストからアルバム・EP を抽出して\nワンタップでまとめて登録';

  @override
  String get loginButtonLabel => 'Spotify でログイン';

  @override
  String get loginFailedMessage => 'ログインに失敗しました';

  @override
  String get clientIdWarningMessage =>
      'SPOTIFY_CLIENT_ID が未設定です。\n--dart-define=SPOTIFY_CLIENT_ID=... を指定して起動してください。';

  @override
  String get retryButtonLabel => '再試行';

  @override
  String genericErrorMessage(Object error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get removeFromPlaylistTooltip => 'このプレイリストから削除';

  @override
  String addedToPlaylistMessage(String targetName, String albumTitle) {
    return '「$targetName」に「$albumTitle」を追加しました';
  }

  @override
  String get addFailedMessage => '追加に失敗しました。もう一度お試しください';

  @override
  String get noTargetsHintMessage => '登録先プレイリストが未設定です。右上の設定から追加してください。';

  @override
  String get authExpiredMessage => 'セッションの有効期限が切れました。再度ログインしてください。';

  @override
  String networkErrorMessage(String message) {
    return 'ネットワークエラーが発生しました（$message）。';
  }

  @override
  String get unknownNetworkErrorMessage => '不明なネットワークエラー';

  @override
  String rateLimitedMessage(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds 秒',
    );
    return 'リクエストが多すぎます。$_temp0後に再試行してください。';
  }

  @override
  String get forbiddenMessage =>
      '権限がないため操作できませんでした。自分が作成した、または共同編集可能なプレイリストのみ操作できます。';

  @override
  String forbiddenMessageWithReason(String reason) {
    return '権限がないため操作できませんでした（$reason）。自分が作成した、または共同編集可能なプレイリストのみ操作できます。';
  }

  @override
  String serverErrorMessage(int statusCode) {
    return 'サーバーエラー（$statusCode）が発生しました。';
  }

  @override
  String notFoundMessage(String resource) {
    return '$resource が見つかりませんでした。';
  }

  @override
  String get unknownErrorMessage => '予期しないエラーが発生しました。';

  @override
  String get resourceLabelPlaylist => 'プレイリスト';

  @override
  String get resourceLabelTrack => 'トラック';

  @override
  String get resourceLabelAlbum => 'アルバム';

  @override
  String get resourceLabelAuthToken => '認証トークン';

  @override
  String get resourceLabelGeneric => 'リソース';
}
