# Changelog

Toutes les modifications notables apportées au projet **Mjumbe** seront documentées dans ce fichier.

## [1.0.0] - 2026-08-18

### Ajouté
- **Architecture** : Mise en place de la Clean Architecture (Data, Domain, Presentation).
- **Gestion d'état** : Intégration complète de `flutter_bloc`.
- **Authentification** : Système complet via Firebase Auth avec gestion explicite des tokens JWT.
- **News** : Flux d'actualités via NewsAPI avec support des catégories.
- **Mode Hors-ligne** : Cache réseau et persistance des signets via Hive.
- **Design** : Thème Dark Glassmorphism personnalisé.
- **Tests** : Suite de tests unitaires et de widgets (Repository, Use Cases, UI).
- **CI/CD** : Pipeline d'intégration continue via GitHub Actions.

### Corrigé
- **Build Android** : Stabilisation des versions Gradle (8.7.0) et Kotlin (2.1.0).
- **Initialisation** : Correction de l'écran noir via une initialisation sécurisée de Firebase et GetIt.
- **NewsAPI** : Correction du flux vide pour la France en basculant sur les sources US par défaut.
- **Injection** : Résolution des conflits d'imports relatifs/package impactant GetIt.

### Sécurité
- Déplacement des secrets (clés API) vers un fichier `.env` non versionné.
- Implémentation d'un intercepteur Dio pour la rotation automatique des tokens JWT.
