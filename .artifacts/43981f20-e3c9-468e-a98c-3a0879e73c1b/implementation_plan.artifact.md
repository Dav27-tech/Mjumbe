# Plan d'amélioration et de fiabilisation du projet Mjumbe

Ce plan vise à répondre aux exigences critiques manquantes, notamment les tests, la gestion avancée de l'authentification et du mode hors-ligne, ainsi que l'amélioration de l'architecture et de la documentation.

## User Review Required

> [!IMPORTANT]
> - **Tests :** Je vais mettre en place une suite de tests unitaires et de widgets pour atteindre les standards de certification.
> - **Authentification :** Je vais rendre explicite la gestion du token JWT via Firebase pour répondre aux exigences OAuth/JWT.
> - **Mode Hors-ligne :** Je vais fiabiliser le service de cache pour garantir que l'application fonctionne parfaitement sans réseau.

## Proposed Changes

### [Testing Infrastructure]

#### [NEW] Suite de tests
- Mise en place de `mockito` ou `mocktail` pour le mocking.
- Création de tests unitaires pour `NewsRepositoryImpl`.
- Création de tests de widgets pour les composants critiques (`NewsFeedPage`).

### [Authentication & Security]

#### [MODIFY] [auth_repository.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/auth/domain/repositories/auth_repository.dart)
- Ajout d'une méthode `Future<String?> getIdToken()` pour exposer le token JWT.

#### [MODIFY] [auth_repository_impl.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/auth/domain/repositories/auth_repository_impl.dart)
- Implémentation de `getIdToken()` via Firebase.

### [Data & Offline Mode]

#### [MODIFY] [news_repository_impl.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/news/data/repositories/news_repository_impl.dart)
- Amélioration de la logique de cache : s'assurer que les données locales sont renvoyées systématiquement en cas d'échec réseau, avec un indicateur clair.

#### [MODIFY] [failures.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/core/error/failures.dart)
- Ajout de types d'erreurs plus granulaires pour une meilleure remontée d'information à l'utilisateur.

### [UI & Architecture]

#### [MODIFY] [news_feed_page.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/news/presentation/pages/news_feed_page.dart)
- Amélioration de l'UI en cas d'erreur réseau (message plus convivial, bouton de reconnexion).

#### [MODIFY] [main.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/main.dart)
- Découplage du `AuthBloc` et du `AppRouter` pour une architecture plus propre (utilisation d'un `AuthRepository` directement dans le router ou via un provider).

### [Documentation]

#### [MODIFY] [README.md](file:///C:/Users/LENOVO/StudioProjects/mjumbe/README.md)
- Ajout d'une section détaillée sur les modèles de données.
- Documentation technique sur l'intégration des APIs et la gestion des tokens JWT.

## Verification Plan

### Automated Tests
- Lancement de `flutter test` pour vérifier la couverture et la réussite des nouveaux tests.

### Manual Verification
- Test du mode avion pour vérifier que les articles mis en cache s'affichent correctement.
- Vérification visuelle de la nouvelle gestion des erreurs réseau.
