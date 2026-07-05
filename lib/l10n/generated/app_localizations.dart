import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// プレイリスト一覧画面のアプリバータイトル。
  ///
  /// In ja, this message translates to:
  /// **'プレイリスト'**
  String get playlistsScreenTitle;

  /// 登録先プレイリスト設定画面を開くアイコンボタンのツールチップ。
  ///
  /// In ja, this message translates to:
  /// **'登録先の設定'**
  String get targetSettingsTooltip;

  /// ログアウトアイコンボタンのツールチップ。
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logoutTooltip;

  /// プレイリストが 1 件もない場合に表示するメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'プレイリストがありません'**
  String get noPlaylistsMessage;

  /// 元プレイリスト名が取得できない場合のアルバム一覧画面のアプリバータイトル。
  ///
  /// In ja, this message translates to:
  /// **'アルバム・EP'**
  String get albumsScreenFallbackTitle;

  /// シングルを一覧に含めるかどうかを切り替えるスイッチのラベル。
  ///
  /// In ja, this message translates to:
  /// **'シングルも表示'**
  String get includeSinglesLabel;

  /// 抽出されたアルバム・EP が 1 件もない場合に表示するメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'アルバム・EP がありません'**
  String get noAlbumsMessage;

  /// 登録先プレイリスト設定画面のアプリバータイトル。
  ///
  /// In ja, this message translates to:
  /// **'登録先プレイリストの設定'**
  String get targetSettingsScreenTitle;

  /// 登録先プレイリスト設定画面の説明文。
  ///
  /// In ja, this message translates to:
  /// **'チェックしたプレイリストが、アルバムのワンタップ登録先になります。'**
  String get targetSettingsDescription;

  /// プレイリストやアルバムの曲数表示。
  ///
  /// In ja, this message translates to:
  /// **'{count} 曲'**
  String trackCount(int count);

  /// ログイン画面に表示するアプリの説明文。
  ///
  /// In ja, this message translates to:
  /// **'プレイリストからアルバム・EP を抽出して\nワンタップでまとめて登録'**
  String get appTagline;

  /// ログインボタンのラベル。
  ///
  /// In ja, this message translates to:
  /// **'Spotify でログイン'**
  String get loginButtonLabel;

  /// AppError 以外の原因でログインに失敗した場合のメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'ログインに失敗しました'**
  String get loginFailedMessage;

  /// SPOTIFY_CLIENT_ID が未設定のときにログイン画面へ表示する警告。
  ///
  /// In ja, this message translates to:
  /// **'SPOTIFY_CLIENT_ID が未設定です。\n--dart-define=SPOTIFY_CLIENT_ID=... を指定して起動してください。'**
  String get clientIdWarningMessage;

  /// エラー表示の再試行ボタンのラベル。
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get retryButtonLabel;

  /// AppError 以外のエラーが発生した場合の汎用メッセージ。
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました: {error}'**
  String genericErrorMessage(Object error);

  /// アルバムをプレイリストから削除するボタンのツールチップ。
  ///
  /// In ja, this message translates to:
  /// **'このプレイリストから削除'**
  String get removeFromPlaylistTooltip;

  /// アルバムを登録先プレイリストへ追加できたときのスナックバーメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'「{targetName}」に「{albumTitle}」を追加しました'**
  String addedToPlaylistMessage(String targetName, String albumTitle);

  /// アルバムの追加に失敗したときのスナックバーメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'追加に失敗しました。もう一度お試しください'**
  String get addFailedMessage;

  /// 登録先プレイリストが 1 件も設定されていないときのヒント。
  ///
  /// In ja, this message translates to:
  /// **'登録先プレイリストが未設定です。右上の設定から追加してください。'**
  String get noTargetsHintMessage;

  /// AppError.authExpired のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'セッションの有効期限が切れました。再度ログインしてください。'**
  String get authExpiredMessage;

  /// AppError.network のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'ネットワークエラーが発生しました（{message}）。'**
  String networkErrorMessage(String message);

  /// ネットワークエラーの詳細メッセージが得られない場合のフォールバック。
  ///
  /// In ja, this message translates to:
  /// **'不明なネットワークエラー'**
  String get unknownNetworkErrorMessage;

  /// AppError.rateLimited のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'リクエストが多すぎます。{seconds, plural, other{{seconds} 秒}}後に再試行してください。'**
  String rateLimitedMessage(int seconds);

  /// AppError.forbidden（理由なし）のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'権限がないため操作できませんでした。自分が作成した、または共同編集可能なプレイリストのみ操作できます。'**
  String get forbiddenMessage;

  /// AppError.forbidden（理由あり）のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'権限がないため操作できませんでした（{reason}）。自分が作成した、または共同編集可能なプレイリストのみ操作できます。'**
  String forbiddenMessageWithReason(String reason);

  /// AppError.server のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'サーバーエラー（{statusCode}）が発生しました。'**
  String serverErrorMessage(int statusCode);

  /// AppError.notFound のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'{resource} が見つかりませんでした。'**
  String notFoundMessage(String resource);

  /// AppError.unknown のユーザー向けメッセージ。
  ///
  /// In ja, this message translates to:
  /// **'予期しないエラーが発生しました。'**
  String get unknownErrorMessage;

  /// ApiResource.playlist の表示名（notFoundMessage の {resource} に使用）。
  ///
  /// In ja, this message translates to:
  /// **'プレイリスト'**
  String get resourceLabelPlaylist;

  /// ApiResource.track の表示名（notFoundMessage の {resource} に使用）。
  ///
  /// In ja, this message translates to:
  /// **'トラック'**
  String get resourceLabelTrack;

  /// ApiResource.album の表示名（notFoundMessage の {resource} に使用）。
  ///
  /// In ja, this message translates to:
  /// **'アルバム'**
  String get resourceLabelAlbum;

  /// ApiResource.authToken の表示名（notFoundMessage の {resource} に使用）。
  ///
  /// In ja, this message translates to:
  /// **'認証トークン'**
  String get resourceLabelAuthToken;

  /// ApiResource.generic の表示名（notFoundMessage の {resource} に使用）。
  ///
  /// In ja, this message translates to:
  /// **'リソース'**
  String get resourceLabelGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
