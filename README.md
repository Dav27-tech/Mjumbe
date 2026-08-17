# 📰 Mjumbe - L'Actualité réinventée

**Mjumbe** (signifiant "Messager" en Swahili) est une application d'agrégation d'actualités moderne et performante. Elle combine une interface **Glassmorphic** futuriste avec une architecture logicielle de pointe pour offrir une expérience de lecture fluide, sécurisée et disponible même hors-ligne.

---

## 🏗️ Architecture : Clean Architecture & BLoC

Le projet suit rigoureusement les principes de la **Clean Architecture** théorisée par Robert C. Martin. L'objectif est de rendre le code **testable**, **indépendant des frameworks** et **facile à maintenir**.

### 1. Couches de l'application
- **Domain Layer (Cœur)** : Contient la logique métier pure (Entités et Cas d'utilisation). Elle est totalement indépendante des bibliothèques externes.
- **Data Layer** : Implémente les interfaces définies par le Domaine. Elle gère les appels réseau (Dio), le stockage local (Hive) et la conversion des données (Models).
- **Presentation Layer** : Gère l'interface utilisateur et la logique d'état via **BLoC**. Elle transforme les événements utilisateur en états UI.

### 2. Flux de données
`UI -> Bloc -> UseCase -> Repository -> DataSource -> API/DB`

---

## 🔒 Authentification & Sécurité (JWT / OAuth)

Mjumbe utilise **Firebase Authentication** comme fournisseur d'identité principal. Bien que Firebase gère l'abstraction complexe, l'application est conçue pour respecter les standards JWT :
- **Token JWT (IdToken)** : Chaque requête vers des services protégés inclut un jeton d'authentification Bearer dans les headers HTTP (via `AuthInterceptor`).
- **Rotation des jetons** : Le système gère automatiquement le rafraîchissement des jetons expirés (Refresh Token flow) pour une session utilisateur continue et sécurisée.
- **Exposition explicite** : Le `AuthRepository` expose une méthode `getIdToken()` permettant d'extraire le jeton brut pour une intégration avec d'autres backends si nécessaire.

---

## 📴 Mode Hors-ligne & Caching (Hive)

L'expérience utilisateur est garantie même sans connexion internet grâce à une stratégie de cache robuste :
1. **Cache Réseau** : Les derniers articles récupérés sont systématiquement stockés dans une "Box" Hive.
2. **Fallback Automatique** : En cas d'échec réseau, le Repository bascule sur les données locales et informe l'utilisateur via un message convivial (SnackBar) et une `OfflineFailure` interne.
3. **Signets (Favoris)** : Les articles marqués par l'utilisateur sont stockés dans une base de données NoSQL locale dédiée, garantissant leur accessibilité permanente.

---

## 🔧 Intégration API & Securité

### NewsAPI
L'application utilise les endpoints suivants de [NewsAPI.org](https://newsapi.org) :
- `GET /v2/top-headlines` : Récupération des actualités à la une.
- `GET /v2/everything` : Recherche globale dans les archives.

**Paramètres clés utilisés :**
- `apiKey` : Authentification via token.
- `country` : Localisation (défaut: `us`).
- `category` : Filtrage thématique.
- `pageSize` : Nombre de résultats par page (défaut: 20).

### Cycle JWT (OAuth 2.0)
Bien que Firebase gère l'authentification, nous implémentons un flux explicite pour garantir la conformité aux standards :
1. **Header Authorization** : Ajout automatique du jeton `Bearer <token>` via un intercepteur Dio.
2. **Auto-Refresh** : Si une erreur `401 Unauthorized` est détectée, l'intercepteur force le rafraîchissement du jeton auprès de Firebase et rejoue la requête originale de manière transparente pour l'utilisateur.

---

## 🆘 Troubleshooting (Dépannage)

### Problème : Écran noir au démarrage
**Cause possible :** Firebase n'est pas initialisé ou le fichier `google-services.json` est manquant.
**Solution :** Vérifiez la présence du fichier dans `android/app/` et assurez-vous que `Firebase.initializeApp()` est appelé dans `main.dart`.

### Problème : Flux d'actualités vide
**Cause possible :** Limites de quota NewsAPI ou pays sans résultats.
**Solution :** Essayez de changer de catégorie ou utilisez la barre de recherche. Vérifiez votre clé API dans le fichier `.env`.

### Problème : Erreur GetIt (Object not registered)
**Cause possible :** Mélange d'imports relatifs et de chemins `package:mjumbe/`.
**Solution :** Utilisez systématiquement des chemins `package:` pour vos imports.

---

## 🧪 Tests & Qualité Logicielle

La qualité du code est assurée par une suite de tests automatisés :
- **Tests Unitaires** : Validation de la logique des Repositories et UseCases avec **Mocktail** (ex: `NewsRepositoryImpl`).
- **Tests de Widgets** : Vérification du comportement des composants UI en fonction des différents états BLoC.
- **Analyse Statique** : Utilisation de `flutter_lints` pour garantir le respect des standards Dart.

Pour lancer les tests :
```bash
flutter test
```

---

## 📊 Modèles de Données (Data Models)

- **ArticleEntity** : L'objet métier pur utilisé dans toute l'application.
- **ArticleModel** : La version "technique" capable de se sérialiser en JSON et de s'adapter au stockage Hive.
- **UserEntity** : Représentation de l'utilisateur connecté (UID, Email, etc.).

---

## 🛠️ Stack Technique & Choix Technologiques

| Technologie | Rôle | Pourquoi ce choix ? |
| :--- | :--- | :--- |
| **Flutter** | Framework UI | Développement multiplateforme avec des performances natives. |
| **BLoC** | State Management | Séparation stricte de l'UI et de la logique, prévisibilité des états. |
| **Dio** | Client HTTP | Gestion avancée des interceptors, timeouts et annulation de requêtes. |
| **Firebase** | Backend & Auth | Sécurité robuste pour l'authentification et gestion cloud simplifiée. |
| **Hive** | Stockage Local | Base de données NoSQL ultra-rapide pour le cache hors-ligne des articles. |
| **GetIt** | Dependency Injection | Découplage des composants pour faciliter les tests unitaires. |
| **GoRouter** | Navigation | Navigation déclarative puissante supportant les redirections (guards). |

---

## 🎨 Design System : Glassmorphism

Mjumbe adopte un style **Dark Glassmorphic**. Ce design repose sur :
- **Backdrop Blur** : Un flou gaussien intense appliqué aux arrière-plans des cartes et des barres.
- **Translucidité** : Des couleurs de surface semi-transparentes avec des bordures fines et lumineuses.
- **Profondeur** : L'utilisation de dégradés et d'ombres pour simuler des couches de verre superposées.

---

## 🚀 Guide d'Installation Complet

> [!IMPORTANT]
> Pour garantir la sécurité, les clés API ne sont pas stockées dans le code source.

### 1. Configuration de l'environnement (.env)
Créez un fichier `.env` à la racine du projet et ajoutez vos clés :
```env
NEWS_API_KEY=votre_cle_ici
NEWS_API_BASE_URL=https://newsapi.org/v2
```

### 2. Configuration Firebase (Obligatoire pour Android)
1. Créez un projet sur la [Console Firebase](https://console.firebase.google.com/).
2. Ajoutez une application Android (`com.mjumbe.mjumbe`).
3. Téléchargez `google-services.json` et placez-le dans `android/app/`.
4. Dans la console Firebase, activez la méthode **Email/Password** dans la section Authentication.

### 3. Lancement
```bash
# 1. Nettoyer les caches
flutter clean

# 2. Récupérer les dépendances
flutter pub get

# 3. Générer les fichiers (Hive TypeAdapters)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Lancer l'application
flutter run
```

---

## 📱 Fonctionnalités Clés

- 🌍 **Flux Global** : Actualités mondiales filtrables par catégories (Tech, Business, Sport, etc.).
- 🔍 **Recherche Intelligente** : Trouvez des articles spécifiques avec des filtres linguistiques.
- 🔖 **Signets** : Enregistrez vos articles préférés pour les lire plus tard.
- 📴 **Mode Hors-ligne** : Accédez à votre cache et à vos signets sans connexion internet.
- 👤 **Profil Utilisateur** : Gestion sécurisée du compte via Firebase.

---

## 🤝 Contribution

1. Forkez le projet.
2. Créez votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`).
3. Commitez vos changements (`git commit -m 'Add AmazingFeature'`).
4. Pushez vers la branche (`git push origin feature/AmazingFeature`).
5. Ouvrez une Pull Request.

---
*Développé par DavSoft.*
