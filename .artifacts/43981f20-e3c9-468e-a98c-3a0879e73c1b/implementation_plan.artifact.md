# Plan d'Excellence Technique et Certification

Ce plan vise à combler les lacunes finales pour la certification du projet : tests intensifs, gestion explicite du cycle JWT, CI/CD, et documentation exhaustive.

## User Review Required

> [!IMPORTANT]
> - **CI/CD** : Je vais ajouter un workflow GitHub Actions qui lancera les tests à chaque push.
> - **JWT** : Je vais rendre le mécanisme de rafraîchissement du token totalement explicite dans l'intercepteur réseau pour répondre aux exigences OAuth strictes.
> - **Tests** : Je vais doubler la couverture de tests en ajoutant des tests pour tous les Use Cases du domaine News.

## Proposed Changes

### [Documentation & Maintenance]

#### [MODIFY] [README.md](file:///C:/Users/LENOVO/StudioProjects/mjumbe/README.md)
- Ajout d'une documentation détaillée sur l'API News (endpoints utilisés, structure des réponses).
- Guide de dépannage (Troubleshooting) pour Firebase et les erreurs réseau.

#### [NEW] [CHANGELOG.md](file:///C:/Users/LENOVO/StudioProjects/mjumbe/CHANGELOG.md)
- Historique des versions et des changements majeurs effectués durant le développement.

### [Authentication & Network Security]

#### [MODIFY] [auth_interceptor.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/core/network/auth_interceptor.dart)
- Implémentation d'une logique de rafraîchissement explicite : si une erreur 401 survient, l'intercepteur demandera un nouveau token via `AuthRepository.getIdToken(forceRefresh: true)` avant de rejouer la requête.

### [Quality & Bug Fixes]

#### [MODIFY] [news_bloc.dart](file:///C:/Users/LENOVO/StudioProjects/mjumbe/lib/features/news/presentation/bloc/news_bloc.dart)
- Correction de `_onToggleBookmark` : ajout de la gestion d'erreur et retour d'état si nécessaire pour notifier l'UI du succès/échec de l'action.

### [Testing & CI/CD]

#### [NEW] [flutter.yml](file:///C:/Users/LENOVO/StudioProjects/mjumbe/.github/workflows/flutter.yml)
- Pipeline d'intégration continue : Checkout -> Flutter Setup -> Pub Get -> Analyze -> Test.

#### [NEW] Suite de tests Use Cases
- `get_top_headlines_test.dart`
- `search_news_test.dart`
- `toggle_bookmark_test.dart`

## Verification Plan

### Automated Tests
- Exécution de `flutter test` pour vérifier le passage de l'intégralité de la suite de tests (nouveaux et anciens).

### Manual Verification
- Simulation d'un token expiré (si possible via debug) pour vérifier que l'intercepteur effectue bien le rafraîchissement silencieux.
