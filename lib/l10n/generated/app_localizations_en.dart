// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get playlistsScreenTitle => 'Playlists';

  @override
  String get targetSettingsTooltip => 'Target playlist settings';

  @override
  String get logoutTooltip => 'Log out';

  @override
  String get noPlaylistsMessage => 'No playlists';

  @override
  String get albumsScreenFallbackTitle => 'Albums & EPs';

  @override
  String get includeSinglesLabel => 'Show singles too';

  @override
  String get noAlbumsMessage => 'No albums or EPs';

  @override
  String get targetSettingsScreenTitle => 'Target playlist settings';

  @override
  String get targetSettingsDescription =>
      'Checked playlists become one-tap add targets for albums.';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '$count track',
    );
    return '$_temp0';
  }

  @override
  String get appTagline =>
      'Extract albums and EPs from playlists\nand add them all in one tap';

  @override
  String get loginButtonLabel => 'Log in with Spotify';

  @override
  String get loginFailedMessage => 'Login failed';

  @override
  String get clientIdWarningMessage =>
      'SPOTIFY_CLIENT_ID is not set.\nLaunch with --dart-define=SPOTIFY_CLIENT_ID=... specified.';

  @override
  String get retryButtonLabel => 'Retry';

  @override
  String genericErrorMessage(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get removeFromPlaylistTooltip => 'Remove from this playlist';

  @override
  String addedToPlaylistMessage(String targetName, String albumTitle) {
    return 'Added \"$albumTitle\" to \"$targetName\"';
  }

  @override
  String get addFailedMessage => 'Failed to add. Please try again.';

  @override
  String get noTargetsHintMessage =>
      'No target playlists are set. Add one from the settings icon in the top right.';

  @override
  String get authExpiredMessage =>
      'Your session has expired. Please log in again.';

  @override
  String networkErrorMessage(String message) {
    return 'A network error occurred ($message).';
  }

  @override
  String get unknownNetworkErrorMessage => 'Unknown network error';

  @override
  String rateLimitedMessage(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconds',
      one: '1 second',
    );
    return 'Too many requests. Try again in $_temp0.';
  }

  @override
  String get forbiddenMessage =>
      'You don\'t have permission to do this. You can only manage playlists you own or can collaborate on.';

  @override
  String forbiddenMessageWithReason(String reason) {
    return 'You don\'t have permission to do this ($reason). You can only manage playlists you own or can collaborate on.';
  }

  @override
  String serverErrorMessage(int statusCode) {
    return 'A server error occurred ($statusCode).';
  }

  @override
  String notFoundMessage(String resource) {
    return '$resource was not found.';
  }

  @override
  String get unknownErrorMessage => 'An unexpected error occurred.';

  @override
  String get resourceLabelPlaylist => 'Playlist';

  @override
  String get resourceLabelTrack => 'Track';

  @override
  String get resourceLabelAlbum => 'Album';

  @override
  String get resourceLabelAuthToken => 'Authentication token';

  @override
  String get resourceLabelGeneric => 'Resource';
}
