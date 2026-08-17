# 📰 Mjumbe — L'actualité réinventée

**Mjumbe** (_« Messager » en Swahili_) est une application mobile d'agrégation d'actualités développée avec **Flutter**.

Elle permet de consulter, rechercher et sauvegarder des actualités avec une interface **Dark Glassmorphic**, un système d'authentification et un fonctionnement partiel **hors-ligne**.

---

## ✨ Fonctionnalités

- 📰 Actualités par catégories
- 🔍 Recherche d'articles
- 🔖 Gestion des favoris
- 📴 Cache et consultation hors-ligne
- 👤 Authentification Firebase
- 🔄 Actualisation des données
- 🌙 Dark Glassmorphism
- ⚡ Gestion des états et erreur

---

## 🏗️ Architecture

Le projet suit les principes de la **Clean Architecture** avec **BLoC** pour la gestion d'état.

```text
Presentation
     ↓
   Domain
     ↓
    Data
```

### Presentation

Interface utilisateur et gestion des états avec BLoC.

### Domain

Logique métier indépendante des frameworks :

- Entities
- UseCases
- Repository Interfaces

### Data

Accès aux données distantes et locales :

- Models
- Repository Implementations
- DataSources
- API / Hive

### Flux de données

```text
UI → BLoC → UseCase → Repository → DataSource → API / Hive
```

---

## 📂 Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   └── injection/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── news/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

---

## 🧠 Gestion d'état — BLoC

Les interactions utilisateur sont transformées en événements, traités par les BLoCs qui produisent ensuite les états correspondants.

```text
Event → BLoC → State → UI
```

Exemple :

```text
FetchNewsEvent
      ↓
NewsLoading
      ↓
NewsLoaded
```

---

## 🌐 API — NewsAPI

Les actualités sont récupérées avec **NewsAPI**.

Endpoints principaux :

```http
GET /v2/top-headlines
GET /v2/everything
```

**Dio** est utilisé pour les requêtes HTTP, les interceptors, les timeouts et la gestion des erreurs.

---

## 🔐 Authentification

**Firebase Authentication** est utilisé pour gérer :

- Inscription
- Connexion
- Déconnexion
- Sessions utilisateur
- Firebase ID Token

Le token peut être transmis à un backend sous la forme :

```http
Authorization: Bearer <token>
```

---

## 📴 Mode hors-ligne

**Hive** est utilisé pour mettre en cache les données locales.

```text
Internet
   ↓
NewsAPI → Repository → Hive
                       ↓
                      UI
```

En cas de problème réseau, le Repository peut utiliser les données précédemment sauvegardées.

Les favoris sont également conservés localement.

---

## 🧩 Injection & Navigation

### GetIt

Utilisé pour l'injection de dépendances et le découplage des composants.

```text
BLoC → UseCase → Repository → DataSource
```

### GoRouter

Utilisé pour la navigation et les redirections liées à l'authentification.

Exemples :

```text
/login
/register
/home
/search
/article/:id
/favorites
/profile
```

---

## 🎨 Design

Mjumbe adopte un **Dark Glassmorphic Design** basé sur :

- 🌑 Dark Theme
- 🪟 Surfaces translucides
- 🌫️ Blur
- ✨ Bordures légères
- 🔘 Coins arrondis
- 💫 Animations subtiles

---

## 📊 Modèles

Les données techniques sont séparées des objets métier.

```text
JSON
 ↓
ArticleModel
 ↓
ArticleEntity
 ↓
Application
```

Cette séparation permet au Domain Layer de rester indépendant de NewsAPI, Hive ou Firebase.

---

## 🧪 Tests

Le projet utilise :

- **Mocktail** pour les mocks
- **flutter_lints** pour l'analyse statique
- Tests unitaires
- Tests BLoC
- Tests de widgets

Commandes :

```bash
flutter test
flutter analyze
```

---

## 🛠️ Stack technique

| Technologie        | Utilisation          |
| ------------------ | -------------------- |
| **Flutter / Dart** | Application mobile   |
| **BLoC**           | Gestion d'état       |
| **Dio**            | HTTP Client          |
| **NewsAPI**        | Actualités           |
| **Firebase Auth**  | Authentification     |
| **Hive**           | Stockage local       |
| **GetIt**          | Dependency Injection |
| **GoRouter**       | Navigation           |
| **Mocktail**       | Tests                |

---

## 🚀 Installation

### 1. Cloner le projet

```bash
git clone <URL_DU_REPOSITORY>
cd mjumbe
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer `.env`

Créer `.env` à la racine :

```env
NEWS_API_KEY=votre_cle
NEWS_API_BASE_URL=https://newsapi.org/v2
```

Ajouter `.env` au `.gitignore`.

### 4. Configurer Firebase

Placer :

```text
android/app/google-services.json
```

Puis activer **Email/Password** dans Firebase Authentication.

### 5. Générer les fichiers

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Lancer

```bash
flutter run
```

---

## ⚠️ Dépannage

### Écran noir

Vérifier :

- Firebase
- `google-services.json`
- Initialisation de Firebase
- Configuration GetIt

### Actualités absentes

Vérifier :

- Connexion Internet
- Clé NewsAPI
- Variables `.env`
- Limites de l'API

### Erreur GetIt

```text
Object/factory ... is not registered
```

Vérifier que toutes les dépendances sont enregistrées avant `runApp()`.

---

## 🔒 Sécurité

Les clés ne doivent pas être écrites directement dans le code.

```gitignore
.env
```

> ⚠️ Une clé API présente dans une application mobile n'est pas totalement secrète. Pour une application en production, un backend intermédiaire est recommandé.

---

## 🗺️ Roadmap

- [ ] Pagination
- [ ] Notifications push
- [ ] Recommandations personnalisées
- [ ] Historique de lecture
- [ ] Synchronisation cloud des favoris
- [ ] Support multilingue
- [ ] Mode clair
- [ ] CI/CD

---

## 👨‍💻 Auteur

**DavSoft**

> _Mjumbe — L'actualité réinventée._ 📰
