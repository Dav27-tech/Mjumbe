// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LUMA NEWS';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get signupTitle => 'Créer un compte';

  @override
  String get emailHint => 'Adresse e-mail';

  @override
  String get passwordHint => 'Mot de passe';

  @override
  String get confirmPasswordHint => 'Confirmer le mot de passe';

  @override
  String get emailInvalid => 'E-mail invalide';

  @override
  String get passwordTooShort => '6 caractères min.';

  @override
  String get passwordMismatch => 'Non identique';

  @override
  String get submitLogin => 'SE CONNECTER';

  @override
  String get submitSignup => 'S\'INSCRIRE';

  @override
  String get toggleSignup => 'Pas de compte ? S\'inscrire';

  @override
  String get toggleLogin => 'Déjà un compte ? Se connecter';

  @override
  String get searchPlaceholder => 'Rechercher une actualité';

  @override
  String get searchHint => 'Rechercher une actualité';

  @override
  String get refresh => 'Actualiser';

  @override
  String get retry => 'Réessayer';

  @override
  String get noResults => 'Aucun résultat disponible';

  @override
  String get profileTitle => 'PROFIL';

  @override
  String get languageLabel => 'Langue';

  @override
  String get frenchLabel => 'Français';

  @override
  String get englishLabel => 'Anglais';

  @override
  String get preferencesLabel => 'Préférences';

  @override
  String get logoutLabel => 'DÉCONNEXION';

  @override
  String get accountVerified => 'Compte Vérifié';

  @override
  String get openArticle => 'Ouvrir l’article original';

  @override
  String get bookmarkAction => 'Action sur le signet effectuée';

  @override
  String get noLink => 'Aucun lien disponible pour cet article.';

  @override
  String get openLinkFailed => 'Impossible d’ouvrir le lien de l’article.';

  @override
  String get errorStartup => 'Erreur de démarrage';

  @override
  String get retryStartup => 'Réessayer';

  @override
  String get searchCategoryGeneral => 'Général';

  @override
  String get searchCategoryTechnology => 'Tech';

  @override
  String get searchCategoryBusiness => 'Business';

  @override
  String get searchCategorySports => 'Sports';

  @override
  String get searchCategoryEntertainment => 'Culture';

  @override
  String get searchCategoryHealth => 'Santé';

  @override
  String get searchCategoryScience => 'Science';

  @override
  String get languageSelectorLabel => 'Sélecteur de langue';

  @override
  String get languageSelectorButton => 'Changer la langue';

  @override
  String get profileButtonLabel => 'Profil';

  @override
  String get logoutButtonLabel => 'Déconnexion';

  @override
  String get searchFieldLabel => 'Champ de recherche';

  @override
  String get bookmarkButtonLabel => 'Favoris';

  @override
  String get openArticleButtonLabel => 'Ouvrir l\'article';

  @override
  String get closeButtonLabel => 'Fermer';

  @override
  String get articleImageLabel => 'Image de l\'article';

  @override
  String get newsFeedTitle => 'LUMA NEWS';

  @override
  String get bookmarksTitle => 'SIGNETS';

  @override
  String get bookmarkEmptyTitle => 'Aucun signet enregistré';

  @override
  String get bookmarkEmptySubtitle =>
      'Retrouvez ici les articles que vous sauvegardez.';

  @override
  String get removeBookmark => 'Retirer le signet';

  @override
  String get articleDetailTitle => 'Détails de l\'article';

  @override
  String get loading => 'Chargement';

  @override
  String get errorState => 'Erreur réseau';
}
