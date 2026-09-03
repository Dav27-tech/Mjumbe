# Changelog

Toutes les modifications notables apportées à LUMA NEWS sont documentées ici.

## [1.2.0] - 2026-09-03

### Ajouté
- support complet de la localisation English / French
- amélioration de l'expérience de navigation avec GoRouter et redirection d'authentification
- écran de profil avec gestion de la langue et déconnexion
- mise à jour de l'interface du flux d'actualités et des états vides / erreurs
- ajout du support de la CI GitHub Actions pour `flutter pub get`, `flutter analyze` et `flutter test`
- documentation projet ajoutée et alignée sur le code réel

### Amélioré
- stabilité du démarrage et de l'initialisation Firebase / GetIt
- gestion du statut hors ligne avec bannière contextuelle
- accessibilité des éléments d'interface clés
- organisation des dépendances et du code de présentation

### Corrigé
- validation de la configuration de workflow GitHub Actions
- ajustements de sécurité et de configuration de l'environnement

## [1.1.0] - 2026-08-25

### Ajouté
- authentification Firebase complète pour les flux de connexion et d'inscription
- écran d'accueil de type flux d'actualités avec catégories et recherche
- vue détaillée des articles avec lien externe
- fonction de signets enregistrés localement dans Hive
- navigation en onglets : Accueil, Signets, Profil

### Amélioré
- gestion des états de chargement, erreur et contenu vide
- intégration de l'API NewsAPI avec gestion des réponses partielles et invalides
- structure de données et logique de persistance des données locales

### Corrigé
- correction du flux d'authentification et de la gestion de session
- résolution des problèmes de configuration liés au plugging Gradle / Android
- stabilisation des dépendances et de l'injection de dépendances

## [1.0.0] - 2026-08-18

### Ajouté
- mise en place de la structure initiale de l'application Flutter
- architecture en couches : Domain, Data, Presentation
- intégration de Flutter BLoC pour la gestion d'état
- service d'actualités NewsAPI
- stockage local avec Hive pour les signets
- configuration de Firebase Core et Firebase Auth
- thème visuel initial et navigation principale
- premiers tests unitaires et widgets

### Corrigé
- stabilisation de la configuration du projet et des dépendances
- correction des imports et de l'injection de dépendances via GetIt
- préparation de la base de la configuration `.env` pour les clés API et Firebase

### Sécurité
- stockage des secrets dans les variables d'environnement plutôt qu'en dur dans le code
- préservation des données sensibles hors dépôt Git
