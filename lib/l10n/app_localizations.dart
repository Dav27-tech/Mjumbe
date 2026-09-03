import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LUMA NEWS'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get signupTitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @submitLogin.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get submitLogin;

  /// No description provided for @submitSignup.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get submitSignup;

  /// No description provided for @toggleSignup.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Sign up'**
  String get toggleSignup;

  /// No description provided for @toggleLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get toggleLogin;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search news'**
  String get searchPlaceholder;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for news'**
  String get searchHint;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results available'**
  String get noResults;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @frenchLabel.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get frenchLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @preferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesLabel;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logoutLabel;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified account'**
  String get accountVerified;

  /// No description provided for @openArticle.
  ///
  /// In en, this message translates to:
  /// **'Open the original article'**
  String get openArticle;

  /// No description provided for @bookmarkAction.
  ///
  /// In en, this message translates to:
  /// **'Bookmark action completed'**
  String get bookmarkAction;

  /// No description provided for @noLink.
  ///
  /// In en, this message translates to:
  /// **'No link available for this article.'**
  String get noLink;

  /// No description provided for @openLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the article link.'**
  String get openLinkFailed;

  /// No description provided for @errorStartup.
  ///
  /// In en, this message translates to:
  /// **'Startup error'**
  String get errorStartup;

  /// No description provided for @retryStartup.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryStartup;

  /// No description provided for @searchCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get searchCategoryGeneral;

  /// No description provided for @searchCategoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get searchCategoryTechnology;

  /// No description provided for @searchCategoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get searchCategoryBusiness;

  /// No description provided for @searchCategorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get searchCategorySports;

  /// No description provided for @searchCategoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get searchCategoryEntertainment;

  /// No description provided for @searchCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get searchCategoryHealth;

  /// No description provided for @searchCategoryScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get searchCategoryScience;

  /// No description provided for @languageSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Language selector'**
  String get languageSelectorLabel;

  /// No description provided for @languageSelectorButton.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get languageSelectorButton;

  /// No description provided for @profileButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileButtonLabel;

  /// No description provided for @logoutButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButtonLabel;

  /// No description provided for @searchFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Search news'**
  String get searchFieldLabel;

  /// No description provided for @bookmarkButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarkButtonLabel;

  /// No description provided for @openArticleButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Open article'**
  String get openArticleButtonLabel;

  /// No description provided for @closeButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButtonLabel;

  /// No description provided for @articleImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Article image'**
  String get articleImageLabel;

  /// No description provided for @newsFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'LUMA NEWS'**
  String get newsFeedTitle;

  /// No description provided for @bookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'BOOKMARKS'**
  String get bookmarksTitle;

  /// No description provided for @bookmarkEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookmark saved'**
  String get bookmarkEmptyTitle;

  /// No description provided for @bookmarkEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your saved articles here.'**
  String get bookmarkEmptySubtitle;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @articleDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Article details'**
  String get articleDetailTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @errorState.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get errorState;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
