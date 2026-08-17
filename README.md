# 📰 Mjumbe — L'actualité réinventée

> **Mjumbe** — « Messager » en Swahili — est une application mobile moderne d'agrégation et de consultation d'actualités développée avec Flutter.

Mjumbe a pour objectif de proposer une expérience de lecture **rapide, moderne, sécurisée et résiliente**, permettant aux utilisateurs de consulter les actualités, rechercher des articles, sauvegarder leurs contenus favoris et continuer à accéder à certaines données même en l'absence de connexion Internet.

L'application combine une interface **Dark Glassmorphic** avec une architecture logicielle basée sur **Clean Architecture + BLoC**, afin de séparer clairement l'interface utilisateur, la logique métier et les sources de données.

---

## 📑 Table des matières

- [✨ Présentation](#-présentation)
- [🎯 Objectifs du projet](#-objectifs-du-projet)
- [🚀 Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture](#️-architecture)
- [📂 Structure du projet](#-structure-du-projet)
- [🔄 Flux de données](#-flux-de-données)
- [🧠 Gestion d'état avec BLoC](#-gestion-détat-avec-bloc)
- [🌐 Intégration NewsAPI](#-intégration-newsapi)
- [🔐 Authentification](#-authentification)
- [🛡️ Sécurité](#️-sécurité)
- [📴 Mode hors-ligne](#-mode-hors-ligne)
- [💾 Stockage local avec Hive](#-stockage-local-avec-hive)
- [🧩 Injection de dépendances](#-injection-de-dépendances)
- [🧭 Navigation](#-navigation)
- [⚠️ Gestion des erreurs](#️-gestion-des-erreurs)
- [🎨 Design System](#-design-system)
- [📊 Modèles de données](#-modèles-de-données)
- [🧪 Tests et qualité](#-tests-et-qualité)
- [🛠️ Stack technique](#️-stack-technique)
- [⚙️ Installation](#️-installation)
- [🔑 Configuration des variables d'environnement](#-configuration-des-variables-denvironnement)
- [🔥 Configuration Firebase](#-configuration-firebase)
- [▶️ Exécution du projet](#️-exécution-du-projet)
- [🐛 Troubleshooting](#-troubleshooting)
- [📏 Conventions de développement](#-conventions-de-développement)
- [🌿 Git et contribution](#-git-et-contribution)
- [🗺️ Roadmap](#️-roadmap)
- [👨‍💻 Auteur](#-auteur)

---

# ✨ Présentation

Mjumbe est conçue autour d'un principe simple :

> **Permettre à l'utilisateur de rester informé sans sacrifier l'expérience utilisateur, la performance ou la disponibilité des données.**

L'application récupère les actualités depuis une API distante, les transforme en modèles exploitables par l'application, les met en cache localement et les expose à l'interface via une architecture découplée.

### Le problème

Les applications d'actualité classiques peuvent présenter plusieurs problèmes :

- dépendance permanente à Internet ;
- interfaces lourdes ou peu ergonomiques ;
- absence de véritable stratégie de cache ;
- logique métier mélangée avec l'interface ;
- difficulté à tester certaines fonctionnalités ;
- gestion complexe des erreurs réseau ;
- faible séparation entre les différentes responsabilités techniques.

### La solution proposée par Mjumbe

Mjumbe répond à ces problèmes grâce à :

- une architecture **Clean Architecture** ;
- une gestion d'état avec **BLoC** ;
- une couche réseau basée sur **Dio** ;
- un cache local avec **Hive** ;
- une authentification avec **Firebase Authentication** ;
- une injection de dépendances avec **GetIt** ;
- une navigation déclarative avec **GoRouter** ;
- une stratégie de fallback permettant de consulter les données précédemment récupérées hors connexion ;
- une interface **Dark Glassmorphic** moderne.

---

# 🎯 Objectifs du projet

Le projet poursuit plusieurs objectifs techniques et fonctionnels.

### Objectifs fonctionnels

- Consulter les actualités.
- Filtrer les actualités par catégorie.
- Rechercher des articles.
- Consulter les détails d'un article.
- Ajouter des articles aux favoris.
- Consulter les favoris hors connexion.
- Conserver un cache des dernières actualités.
- Authentifier les utilisateurs.
- Maintenir une expérience utilisateur cohérente en cas de perte de connexion.

### Objectifs techniques

- Appliquer les principes de la Clean Architecture.
- Séparer la logique métier de l'interface.
- Utiliser une gestion d'état prévisible avec BLoC.
- Faciliter les tests unitaires.
- Réduire le couplage entre les composants.
- Centraliser l'injection des dépendances.
- Gérer proprement les erreurs.
- Mettre en place une stratégie de cache.
- Faciliter l'évolution future du projet.

---

# 🚀 Fonctionnalités

## 🌍 Actualités

L'utilisateur peut consulter un flux d'articles provenant de différentes catégories.

Exemples :

- 📰 Général
- 💻 Technologie
- 💼 Business
- ⚽ Sport
- 🎬 Divertissement
- 🩺 Santé
- 🔬 Science

Les données sont récupérées depuis **NewsAPI** puis transformées en objets métier utilisés par l'application.

---

## 🔍 Recherche

L'utilisateur peut rechercher des articles à partir de mots-clés.

La recherche utilise l'endpoint :

```text
GET /v2/everything
```

Elle peut être combinée avec différents paramètres de filtrage proposés par NewsAPI.

---

## 🔖 Favoris

Un utilisateur peut sauvegarder un article afin de le consulter ultérieurement.

Les favoris sont conservés localement afin de rester accessibles même lorsque l'appareil est hors connexion.

---

## 📴 Consultation hors connexion

Mjumbe conserve localement certaines données précédemment récupérées.

En cas de problème réseau :

```text
Internet disponible
       ↓
API distante
       ↓
Articles
       ↓
Hive
       ↓
Interface
```

En cas de perte de connexion :

```text
Internet indisponible
       ↓
API échoue
       ↓
Repository
       ↓
Cache Hive
       ↓
Articles précédemment sauvegardés
       ↓
Interface
```

L'utilisateur peut ainsi continuer à consulter les données disponibles localement.

---

## 👤 Authentification

L'application utilise **Firebase Authentication** pour gérer l'identité des utilisateurs.

Les fonctionnalités peuvent notamment inclure :

- création de compte ;
- connexion ;
- déconnexion ;
- récupération de session ;
- récupération des informations utilisateur ;
- récupération du Firebase ID Token.

---

# 🏗️ Architecture

Mjumbe suit les principes de la **Clean Architecture**.

L'objectif principal est de séparer :

- la logique métier ;
- l'accès aux données ;
- l'interface utilisateur ;
- les frameworks et services externes.

L'architecture est organisée autour de trois grandes couches :

```text
┌───────────────────────────────┐
│        PRESENTATION           │
│       Flutter + BLoC          │
└───────────────┬───────────────┘
                │
                ↓
┌───────────────────────────────┐
│           DOMAIN              │
│ Entities + UseCases +         │
│ Repository Contracts          │
└───────────────┬───────────────┘
                │
                ↓
┌───────────────────────────────┐
│             DATA              │
│ Repository Impl + DataSources │
│ Models + API + Hive            │
└───────────────────────────────┘
```

---

# 🧱 Les trois couches

## 1. Domain Layer

Le **Domain Layer** représente le cœur de l'application.

Il ne doit pas dépendre de Flutter, Dio, Hive, Firebase ou d'une autre technologie externe.

Il contient principalement :

```text
Entities
UseCases
Repository Interfaces
Failures
```

### Exemple

```dart
abstract class NewsRepository {
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines();
}
```

Le Domain Layer définit **ce qui doit être fait**, mais ne sait pas **comment cela est réalisé**.

---

## 2. Data Layer

Le Data Layer fournit les implémentations concrètes demandées par le Domain Layer.

Il contient notamment :

```text
Repository Implementations
Remote DataSources
Local DataSources
Models
API clients
Hive adapters
Firebase integrations
```

Exemple :

```text
NewsRepository
      ↑
      │
NewsRepositoryImpl
      │
      ├── NewsRemoteDataSource
      │         ↓
      │       Dio
      │         ↓
      │      NewsAPI
      │
      └── NewsLocalDataSource
                ↓
              Hive
```

Le Repository décide notamment s'il doit utiliser :

- la source distante ;
- la source locale ;
- ou une combinaison des deux.

---

## 3. Presentation Layer

La Presentation Layer contient tout ce qui concerne l'interface utilisateur.

Elle comprend notamment :

```text
Pages / Screens
Widgets
BLoCs
Events
States
UI helpers
```

Le principe est de ne pas placer directement la logique métier complexe dans les widgets.

Exemple :

```text
User interaction
      ↓
BLoC Event
      ↓
UseCase
      ↓
Repository
      ↓
DataSource
```

---

# 🔄 Flux de données

Le flux principal de Mjumbe suit cette direction :

```text
UI
 ↓
BLoC
 ↓
UseCase
 ↓
Repository Interface
 ↓
Repository Implementation
 ↓
DataSource
 ↓
API / Local Database
```

### Exemple : chargement des actualités

```text
HomePage
   │
   │ dispatch FetchNewsEvent
   ↓
NewsBloc
   │
   │ execute()
   ↓
GetTopHeadlinesUseCase
   │
   ↓
NewsRepository
   │
   ↓
NewsRepositoryImpl
   │
   ├──────────────→ RemoteDataSource → NewsAPI
   │
   └──────────────→ LocalDataSource  → Hive
   │
   ↓
ArticleEntity
   ↓
NewsState
   ↓
UI
```

---

# 🧠 Gestion d'état avec BLoC

Mjumbe utilise **BLoC (Business Logic Component)** pour gérer les états de l'application.

Le principe est :

```text
Event → BLoC → State
```

Par exemple :

```dart
FetchNewsEvent
```

peut produire :

```text
NewsLoading
      ↓
NewsLoaded
```

ou :

```text
NewsLoading
      ↓
NewsError
```

---

## Exemple de cycle BLoC

```text
Utilisateur
     │
     │ actualise la page
     ↓
FetchNewsEvent
     │
     ↓
NewsBloc
     │
     ↓
GetTopHeadlinesUseCase
     │
     ↓
Repository
     │
     ↓
API
     │
     ↓
NewsLoaded
     │
     ↓
Interface
```

Cette approche permet de rendre l'état de l'interface prévisible.

---

# 🌐 Intégration NewsAPI

Mjumbe utilise **NewsAPI** comme source distante d'actualités.

Deux endpoints principaux sont utilisés.

## Top Headlines

```http
GET /v2/top-headlines
```

Utilisé pour récupérer les actualités principales.

Exemple de paramètres :

```text
apiKey
country
category
pageSize
page
```

---

## Recherche globale

```http
GET /v2/everything
```

Utilisé pour rechercher des articles selon différents critères.

Exemple :

```text
q
language
from
to
sortBy
pageSize
page
```

---

## Couche réseau

Les requêtes HTTP sont réalisées avec **Dio**.

Cette couche permet notamment de gérer :

- les headers ;
- les paramètres ;
- les timeouts ;
- les erreurs HTTP ;
- les interceptors ;
- l'authentification ;
- l'annulation éventuelle des requêtes.

---

# 🔐 Authentification

Mjumbe utilise **Firebase Authentication** comme fournisseur d'identité.

Firebase gère notamment :

- l'identification de l'utilisateur ;
- les sessions ;
- les tokens ;
- le renouvellement des tokens ;
- les différents providers d'authentification activés.

---

## Firebase ID Token

Lorsqu'un utilisateur est authentifié, Firebase peut fournir un **ID Token**.

Ce token est un **JWT (JSON Web Token)**.

Lorsqu'un backend externe doit vérifier l'identité de l'utilisateur, le token peut être transmis sous la forme :

```http
Authorization: Bearer <id-token>
```

---

## Récupération du token

L'application peut centraliser cette opération dans le repository d'authentification :

```dart
Future<String?> getIdToken();
```

Cela évite que les autres couches aient à manipuler directement `FirebaseAuth`.

---

# 🔄 Rafraîchissement des tokens

Les Firebase ID Tokens ont une durée de validité limitée.

L'application s'appuie sur Firebase pour maintenir une session valide et peut demander un token actualisé lorsqu'une requête nécessite une authentification.

Avec Dio, un `AuthInterceptor` peut centraliser l'ajout du token :

```text
Request
   ↓
AuthInterceptor
   ↓
Get Firebase ID Token
   ↓
Authorization: Bearer <token>
   ↓
API
```

En cas de réponse `401 Unauthorized`, une stratégie de renouvellement peut être utilisée avant de rejouer la requête, en prenant soin d'éviter les boucles infinies.

---

# 🛡️ Sécurité

La sécurité est prise en compte à plusieurs niveaux.

## Variables sensibles

Les clés de configuration ne doivent pas être directement écrites dans le code source :

```dart
const apiKey = "xxxxxxxx";
```

À la place, la configuration peut être chargée depuis un fichier `.env` pendant le développement.

---

## ⚠️ Important concernant les clés API mobiles

Un fichier `.env` dans une application Flutter **ne constitue pas une protection absolue d'un secret**.

Une application mobile distribuée peut être analysée et ses ressources ou certaines valeurs de configuration peuvent être récupérées.

Ainsi :

```text
.env
   ≠
Secret totalement sécurisé
```

Pour une véritable protection d'une clé privée, l'architecture recommandée est :

```text
Flutter App
     ↓
Backend sécurisé
     ↓
NewsAPI
```

La clé NewsAPI reste alors côté serveur.

Pour un projet académique ou de démonstration, l'utilisation d'une configuration `.env` peut néanmoins être acceptable pour éviter de publier directement la clé dans Git.

---

# 📴 Mode hors-ligne

Mjumbe adopte une stratégie de **cache avec fallback local**.

## Fonctionnement normal

```text
Internet
   ↓
NewsAPI
   ↓
Repository
   ↓
Hive
   ↓
UI
```

Les données récupérées sont également enregistrées localement.

---

## Fonctionnement hors connexion

```text
Internet
   X
   ↓
Network Failure
   ↓
Repository
   ↓
Hive
   ↓
Cached Articles
   ↓
UI
```

L'application ne considère donc pas automatiquement une erreur réseau comme une absence totale de données.

---

# 💾 Stockage local avec Hive

**Hive** est utilisé comme stockage NoSQL local.

Il peut être utilisé pour conserver :

- les articles récemment récupérés ;
- les favoris ;
- certaines préférences utilisateur ;
- d'autres données nécessaires au fonctionnement hors ligne.

---

## Exemple de stratégie

```text
Remote DataSource
       ↓
     API
       ↓
   ArticleModel
       ↓
     Hive
```

Puis :

```text
Hive
 ↓
ArticleModel
 ↓
ArticleEntity
 ↓
Presentation
```

Cette séparation permet de conserver la distinction entre les données techniques et les objets métier.

---

# 🧩 Injection de dépendances

Mjumbe utilise **GetIt** pour gérer les dépendances.

L'objectif est d'éviter de créer directement les objets complexes dans les widgets.

Sans injection :

```dart
final repository = NewsRepositoryImpl(
  NewsRemoteDataSource(
    Dio(),
  ),
);
```

Avec injection :

```dart
final repository = getIt<NewsRepository>();
```

---

## Exemple de chaîne de dépendances

```text
NewsBloc
   ↓
GetTopHeadlinesUseCase
   ↓
NewsRepository
   ↓
NewsRepositoryImpl
   ↓
NewsRemoteDataSource
   ↓
Dio
```

GetIt permet de construire cette chaîne une seule fois et de fournir les dépendances nécessaires aux différents composants.

---

# 🧭 Navigation

Mjumbe utilise **GoRouter** pour gérer la navigation.

GoRouter permet notamment :

- navigation déclarative ;
- routes nommées ;
- paramètres de route ;
- redirections ;
- gestion de l'état d'authentification ;
- deep linking ;
- navigation imbriquée.

Une structure typique peut être :

```text
/
├── /home
├── /search
├── /article/:id
├── /favorites
├── /profile
├── /login
└── /register
```

---

# ⚠️ Gestion des erreurs

Les erreurs provenant des différentes couches sont transformées en erreurs compréhensibles par le Domain Layer.

Exemples :

```text
NetworkFailure
ServerFailure
CacheFailure
AuthFailure
OfflineFailure
UnknownFailure
```

L'objectif est d'éviter que la Presentation Layer connaisse directement les exceptions de Dio, Firebase ou Hive.

---

## Exemple

Au lieu d'exposer directement :

```dart
DioException
```

le Repository peut retourner :

```dart
NetworkFailure()
```

Le BLoC peut alors transformer cette erreur en état :

```text
NewsError
```

et l'interface afficher :

```text
Impossible de charger les actualités.
Vérifiez votre connexion Internet.
```

---

# 🎨 Design System — Dark Glassmorphism

Mjumbe utilise une direction artistique **Dark Glassmorphic**.

L'objectif est de créer une interface :

- moderne ;
- immersive ;
- légère visuellement ;
- cohérente ;
- orientée contenu.

---

## Principes visuels

### 🪟 Glass Effect

Les composants utilisent des surfaces semi-transparentes donnant une impression de verre.

```text
Background
     ↓
Blur
     ↓
Semi-transparent Surface
     ↓
Border
     ↓
Content
```

---

### 🌫️ Backdrop Blur

Le `BackdropFilter` peut être utilisé pour produire un effet de flou derrière certaines surfaces.

---

### 🌓 Dark Theme

L'application privilégie un environnement sombre afin de :

- renforcer l'aspect premium ;
- améliorer la hiérarchie visuelle ;
- mettre les images et titres en avant ;
- conserver une identité graphique cohérente.

---

### 📐 Composants

Les composants suivent des principes communs :

- bordures arrondies ;
- espaces réguliers ;
- surfaces translucides ;
- ombres douces ;
- typographie hiérarchisée ;
- animations discrètes ;
- icônes cohérentes.

---

# 📊 Modèles de données

Mjumbe distingue les **Entities** du Domain Layer et les **Models** du Data Layer.

---

## ArticleEntity

Objet métier utilisé par les différentes couches de l'application.

Exemple conceptuel :

```dart
class ArticleEntity {
  final String title;
  final String? description;
  final String? imageUrl;
  final String? author;
  final DateTime? publishedAt;
  final String url;
}
```

L'Entity ne dépend pas de Hive, Dio ou d'un autre framework.

---

## ArticleModel

Le Model représente la version technique des données.

Il peut être utilisé pour :

- parser le JSON de NewsAPI ;
- convertir les données en Entity ;
- sérialiser les données ;
- stocker les données dans Hive.

Flux :

```text
JSON
 ↓
ArticleModel
 ↓
ArticleEntity
 ↓
Application
```

---

## UserEntity

Représente l'utilisateur au niveau métier.

Exemples d'informations :

```text
uid
email
displayName
photoUrl
```

L'objectif est de ne pas propager directement les objets Firebase dans toute l'application.

---

# 🧪 Tests et qualité

La qualité du code repose sur plusieurs niveaux de tests.

## Tests unitaires

Ils permettent de tester indépendamment :

- UseCases ;
- Repositories ;
- logique métier ;
- parsing ;
- gestion des erreurs.

Exemple :

```text
GetTopHeadlinesUseCase
        ↓
Mock Repository
        ↓
Expected Result
```

---

## Mocktail

**Mocktail** est utilisé pour simuler les dépendances pendant les tests.

Cela permet de tester une classe sans appeler réellement :

- NewsAPI ;
- Firebase ;
- Hive ;
- Dio.

---

## Tests BLoC

Les BLoCs peuvent être testés en vérifiant la séquence :

```text
Event
 ↓
Loading
 ↓
Success
```

ou :

```text
Event
 ↓
Loading
 ↓
Error
```

---

## Tests de widgets

Les widgets peuvent être testés selon les différents états :

```text
Loading
Loaded
Empty
Error
Offline
```

---

## Analyse statique

Le projet utilise `flutter_lints` afin de détecter :

- erreurs potentielles ;
- mauvaises pratiques ;
- problèmes de style ;
- code inutile ;
- incohérences.

---

## Exécuter les tests

```bash
flutter test
```

Pour analyser le projet :

```bash
flutter analyze
```

---

# 🛠️ Stack technique

| Technologie                 | Rôle                 | Justification                            |
| --------------------------- | -------------------- | ---------------------------------------- |
| **Flutter**                 | Framework mobile     | Développement multiplateforme            |
| **Dart**                    | Langage              | Langage natif de Flutter                 |
| **BLoC**                    | State Management     | Séparation UI / logique                  |
| **Dio**                     | HTTP Client          | Interceptors, timeout et gestion réseau  |
| **Firebase Authentication** | Authentification     | Gestion de l'identité et des sessions    |
| **Hive**                    | Base locale          | Stockage NoSQL rapide                    |
| **GetIt**                   | Dependency Injection | Découplage et testabilité                |
| **GoRouter**                | Navigation           | Navigation déclarative et redirections   |
| **NewsAPI**                 | Source d'actualités  | Fourniture des données                   |
| **Mocktail**                | Tests                | Mocking des dépendances                  |
| **flutter_lints**           | Analyse              | Qualité et conventions Dart              |
| **flutter_dotenv**          | Configuration        | Chargement des variables d'environnement |

---

# 📂 Structure du projet

Une organisation indicative du projet :

```text
lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   ├── utils/
│   └── injection/
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── news/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
│
└── main.dart
```

---

# ⚙️ Installation

## Prérequis

Avant de commencer, installer :

- Flutter SDK ;
- Dart SDK compatible avec Flutter ;
- Android Studio ou un environnement équivalent ;
- Android SDK pour Android ;
- Git ;
- un compte Firebase ;
- une clé NewsAPI.

Vérifier l'installation :

```bash
flutter doctor
```

Puis :

```bash
flutter --version
```

---

# 📥 Cloner le projet

```bash
git clone <URL_DU_REPOSITORY>
```

Entrer dans le projet :

```bash
cd mjumbe
```

---

# 📦 Installer les dépendances

```bash
flutter pub get
```

Si nécessaire :

```bash
flutter clean
flutter pub get
```

---

# 🔑 Configuration des variables d'environnement

Créer un fichier :

```text
.env
```

à la racine du projet.

Exemple :

```env
NEWS_API_KEY=votre_cle_ici
NEWS_API_BASE_URL=https://newsapi.org/v2
```

### ⚠️ Ne jamais versionner `.env`

Ajouter le fichier dans `.gitignore` :

```gitignore
.env
```

Il est recommandé de fournir un exemple :

```text
.env.example
```

contenant uniquement :

```env
NEWS_API_KEY=
NEWS_API_BASE_URL=https://newsapi.org/v2
```

Cela permet aux autres développeurs de comprendre quelles variables sont nécessaires.

---

# 🔥 Configuration Firebase

## 1. Créer un projet Firebase

Créer un projet depuis la console Firebase.

---

## 2. Ajouter l'application Android

Utiliser le package name correspondant à l'application :

```text
com.mjumbe.mjumbe
```

---

## 3. Télécharger la configuration

Télécharger :

```text
google-services.json
```

Puis le placer dans :

```text
android/app/google-services.json
```

---

## 4. Activer Firebase Authentication

Dans Firebase :

```text
Authentication
    ↓
Sign-in method
    ↓
Email/Password
```

Activer le provider nécessaire.

---

## 5. Initialiser Firebase

L'application doit initialiser Firebase avant son utilisation.

Le principe est :

```dart
await Firebase.initializeApp();
```

Cette initialisation doit être effectuée avant le lancement des fonctionnalités dépendantes de Firebase.

---

# 🏃 Exécution du projet

Après la configuration :

```bash
flutter clean
```

Puis :

```bash
flutter pub get
```

Générer les fichiers nécessaires :

```bash
dart run build_runner build --delete-conflicting-outputs
```

Enfin :

```bash
flutter run
```

---

# 🔄 Génération des fichiers

Si Hive ou d'autres générateurs de code sont utilisés :

```bash
dart run build_runner build --delete-conflicting-outputs
```

Pour une génération continue pendant le développement :

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

# 🐛 Troubleshooting

## Écran noir au démarrage

### Causes possibles

- Firebase non initialisé ;
- `google-services.json` absent ;
- erreur lors de l'injection des dépendances ;
- exception dans `main.dart`.

### Vérifications

```dart
await Firebase.initializeApp();
```

Vérifier également :

```text
android/app/google-services.json
```

Puis :

```bash
flutter clean
flutter pub get
flutter run
```

---

# 📰 Le flux d'actualités est vide

### Causes possibles

- clé NewsAPI incorrecte ;
- variable `.env` non chargée ;
- problème réseau ;
- mauvais paramètre `country` ;
- mauvais paramètre `category` ;
- limite ou restriction imposée par le fournisseur API ;
- réponse API contenant zéro article.

### Vérifications

Vérifier :

```env
NEWS_API_KEY=...
NEWS_API_BASE_URL=https://newsapi.org/v2
```

Puis vérifier les logs réseau de Dio.

---

# 🔑 Erreur liée à l'API Key

Vérifier que la clé est correctement chargée.

Éviter de faire :

```dart
print(apiKey);
```

dans une version de production.

Ne jamais publier une clé API privée dans GitHub.

---

# 🧩 Erreur GetIt : Object not registered

Erreur typique :

```text
Bad state: Object/factory with type ... is not registered inside GetIt
```

### Cause

Une dépendance est utilisée avant d'avoir été enregistrée.

Vérifier l'ordre d'initialisation :

```text
main()
 ↓
Dependencies registration
 ↓
runApp()
```

---

# 📦 Problèmes avec les imports

Pour conserver une structure cohérente, privilégier les imports `package:` :

```dart
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
```

plutôt que de mélanger plusieurs styles d'import.

Cela permet également d'éviter certains problèmes liés à des chemins relatifs différents vers un même fichier.

---

# 🧱 Erreurs de génération Hive / build_runner

Si les fichiers générés deviennent incohérents :

```bash
dart run build_runner clean
```

Puis :

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

# 📏 Conventions de développement

## Nommage

Les fichiers suivent généralement le format :

```text
snake_case.dart
```

Exemple :

```text
news_repository_impl.dart
article_entity.dart
get_top_headlines.dart
```

Les classes utilisent :

```text
PascalCase
```

Exemple :

```dart
class ArticleEntity {}
class NewsRepositoryImpl {}
```

Les variables et méthodes utilisent :

```text
camelCase
```

Exemple :

```dart
final articleList;
```

---

# 🧠 Principes architecturaux

Quelques règles importantes :

### Domain

Le Domain ne doit pas dépendre de :

```text
Flutter
Dio
Hive
Firebase
```

---

### Presentation

Les widgets ne doivent pas appeler directement :

```text
Dio
Firebase
Hive
```

Ils communiquent principalement avec les BLoCs.

---

### Data

La Data Layer connaît les détails techniques :

```text
API
JSON
Dio
Hive
Firebase
```

mais ces détails ne doivent pas contaminer inutilement le Domain Layer.

---

# 🧪 Exemple de responsabilité

### ❌ À éviter

```text
Widget
 ↓
Dio
 ↓
NewsAPI
```

### ✅ Architecture Mjumbe

```text
Widget
 ↓
BLoC
 ↓
UseCase
 ↓
Repository
 ↓
DataSource
 ↓
Dio
 ↓
NewsAPI
```

Cette séparation améliore :

- la testabilité ;
- la maintenance ;
- la lisibilité ;
- la réutilisation ;
- l'évolutivité.

---

# 🌿 Git et contribution

## Créer une branche

```bash
git checkout -b feature/news-search
```

ou :

```bash
git checkout -b fix/auth-token
```

---

## Convention de commits

Utiliser des messages explicites.

Exemples :

```text
feat: add news search
fix: handle offline news loading
refactor: improve news repository
test: add news bloc tests
docs: update installation guide
style: improve article card
```

---

## Workflow

```bash
git checkout -b feature/AmazingFeature
```

Développer la fonctionnalité puis :

```bash
git add .
git commit -m "feat: add AmazingFeature"
```

Envoyer la branche :

```bash
git push origin feature/AmazingFeature
```

Puis créer une Pull Request.

---

# 🧪 Vérification avant Pull Request

Avant de proposer une modification :

```bash
flutter analyze
```

Puis :

```bash
flutter test
```

Et enfin vérifier que l'application fonctionne :

```bash
flutter run
```

---

# 🗺️ Roadmap

Les fonctionnalités suivantes peuvent être envisagées pour les futures versions.

## Phase actuelle

- [x] Architecture Clean Architecture
- [x] Gestion d'état BLoC
- [x] Intégration NewsAPI
- [x] Authentification Firebase
- [x] Cache local Hive
- [x] Favoris
- [x] Navigation GoRouter
- [x] Design Glassmorphic
- [x] Gestion des erreurs
- [x] Tests automatisés

## Évolutions possibles

- [ ] Pagination avancée
- [ ] Pull-to-refresh
- [ ] Notifications push
- [ ] Articles recommandés
- [ ] Historique de lecture
- [ ] Synchronisation des favoris avec le cloud
- [ ] Mode lecture amélioré
- [ ] Partage d'articles
- [ ] Gestion de plusieurs langues
- [ ] Personnalisation du flux
- [ ] Thème clair
- [ ] Analytics
- [ ] Backend intermédiaire pour protéger les clés API
- [ ] Tests d'intégration
- [ ] CI/CD
- [ ] Déploiement automatisé

---

# 🔬 Évolutions architecturales possibles

L'architecture actuelle permet également de faire évoluer progressivement le projet.

Par exemple, NewsAPI pourrait être remplacée par une autre source :

```text
                ┌── NewsAPI
                │
Repository ─────┼── Backend Mjumbe
                │
                └── AnotherNewsAPI
```

Le Domain Layer pourrait rester pratiquement inchangé si les nouveaux DataSources respectent les mêmes contrats.

C'est précisément l'un des avantages recherchés avec la Clean Architecture :

> **Les détails techniques peuvent évoluer sans réécrire le cœur métier.**

---

# 📈 Vision du projet

Mjumbe peut évoluer d'une simple application de consultation d'actualités vers une véritable plateforme personnalisée.

Une architecture possible à long terme :

```text
                    ┌──────────────┐
                    │ Flutter App  │
                    └──────┬───────┘
                           │
                           ↓
                    ┌──────────────┐
                    │ Mjumbe API   │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              ↓            ↓            ↓
         News Sources   Database    Auth Service
              │            │            │
              └────────────┼────────────┘
                           ↓
                    Personalization
```

Cela permettrait à terme d'introduire :

- personnalisation des actualités ;
- recommandations ;
- profils utilisateur avancés ;
- synchronisation cloud ;
- statistiques ;
- notifications personnalisées ;
- agrégation de plusieurs sources.

---

# 📱 Plateformes

L'application est développée avec Flutter et peut être adaptée aux plateformes supportées par Flutter.

La cible principale du projet est actuellement :

```text
Android
```

L'architecture permet cependant d'envisager ultérieurement :

```text
Android
iOS
Web
Desktop
```

avec des adaptations spécifiques lorsque certaines dépendances ou fonctionnalités sont propres à une plateforme.

---

# 📌 Résumé technique

```text
                    MJUMBE
                      │
          ┌───────────┴───────────┐
          │                       │
      Presentation              Core
          │                       │
        BLoC                Network / Errors
          │                   Theme / Routes
          ↓
       Domain
          │
    ┌─────┼─────┐
    ↓     ↓     ↓
Entities UseCases Repositories
          │
          ↓
         Data
          │
    ┌─────┼─────────────┐
    ↓     ↓             ↓
  Models Remote       Local
          │             │
          ↓             ↓
        Dio            Hive
          │
          ↓
       NewsAPI

Authentication
       │
       ↓
Firebase Authentication
```

---

# 📄 Licence

Le projet peut être distribué selon la licence définie par les mainteneurs du projet.

Si aucune licence n'est encore définie, il est recommandé d'en ajouter une avant une distribution publique.

---

# 👨‍💻 Auteur

**Développé par DavSoft**

> _Mjumbe — Bringing the world's news closer to you._

---

## ⭐ Pourquoi Mjumbe ?

Mjumbe n'est pas uniquement une application Flutter permettant d'afficher des articles.

Le projet sert également de démonstration d'une architecture moderne permettant de construire une application :

- **maintenable** ;
- **testable** ;
- **évolutive** ;
- **résiliente aux problèmes réseau** ;
- **découplée des frameworks** ;
- **orientée expérience utilisateur**.

L'association **Clean Architecture + BLoC + Repository Pattern + Dependency Injection + Local Cache** permet de construire une base solide sur laquelle de nouvelles fonctionnalités peuvent être ajoutées sans remettre en cause toute l'application.

**Mjumbe — L'actualité réinventée. 📰**
