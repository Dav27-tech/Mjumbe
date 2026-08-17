# Plan de Finalisation pour la Certification (Tests & Sécurité)

Ce plan vise à combler les lacunes persistantes identifiées : manque de tests unitaires sur les dépôts (repositories) et implémentation incomplète de la gestion réseau/authentification (JWT/OAuth).

## User Review Required

> [!IMPORTANT]
> - **Tests de Dépôts** : Je vais ajouter une couverture complète de tests unitaires pour `AuthRepositoryImpl` et finaliser ceux de `NewsRepositoryImpl`. C'est une exigence critique pour le score final.
> - **Gestion JWT/OAuth** : Je vais rendre la gestion des jetons OAuth encore plus explicite dans l'architecture pour satisfaire les critères de conformité réseau.
> - **Feedback Utilisateur** : J'assurerai une gestion des erreurs réseau uniforme sur tous les écrans.

## Proposed Changes

### [Repository Unit Tests]

#### [NEW] [auth_repository_impl_test.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/test/features/auth/data/repositories/auth_repository_impl_test.dart)
- Tests pour `signIn`, `signUp`, `signOut`.
- Test pour `getIdToken` (vérification du rafraîchissement forcé).
- Mocking de `FirebaseAuth`.

#### [MODIFY] [news_repository_impl_test.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/test/features/news/data/repositories/news_repository_impl_test.dart)
- Ajout de tests pour `searchNews`, `toggleBookmark`, `getBookmarkedArticles`.
- Test de la logique de basculement vers le cache pour chaque méthode.

### [Authentication & Network]

#### [MODIFY] [auth_repository.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/auth/domain/repositories/auth_repository.dart)
- Renommer ou ajouter une méthode `getOAuth2AccessToken()` pour une nomenclature plus conforme aux standards industriels.

#### [MODIFY] [auth_interceptor.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/core/network/auth_interceptor.dart)
- Amélioration de la résilience : ajout d'une tentative de rejeu automatique plus propre et logging détaillé des phases de rafraîchissement JWT.

### [Error Handling & UI]

#### [MODIFY] [news_feed_page.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/news/presentation/pages/news_feed_page.dart)
- Harmonisation des messages d'erreur et ajout d'un indicateur visuel de "Données en cache" plus explicite.

## Verification Plan

### Automated Tests
- Lancement de `flutter test` avec vérification de la couverture des fichiers `repository_impl.dart`.

### Manual Verification
- Test en mode hors-ligne complet pour confirmer la persistance et le feedback utilisateur.
