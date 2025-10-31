# MOONGO - Rapport d'Architecture Technique

## 📊 Vue d'Ensemble du Projet

### Informations Générales

- **Nom du Projet** : MOONGO
- **Type** : Application Mobile Flutter
- **Architecture** : MVVM (avec Stacked)
- **Backend** : Firebase (Auth, Firestore, Cloud Messaging)
- **Version Actuelle** : 0.1.0 (Squelette)
- **Date de Création** : 31 octobre 2025

### Objectif

Créer une application de gestion de routines avec gamification permettant aux utilisateurs de faire évoluer des créatures en complétant des tâches quotidiennes.

---

## 🏛️ Architecture Logicielle

### Pattern MVVM avec Stacked

```
┌─────────────────────────────────────────────────────┐
│                      VIEW                           │
│  (Composants UI - Stateless Widgets)                │
│  - Affichage des données                            │
│  - Gestion des interactions utilisateur             │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ Binding via StackedView<T>
                  │
┌─────────────────▼───────────────────────────────────┐
│                   VIEW MODEL                        │
│  (Logique de présentation - BaseViewModel)          │
│  - État de la vue                                   │
│  - Logique métier de la vue                         │
│  - Appels aux services                              │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ Dependency Injection (Locator)
                  │
┌─────────────────▼───────────────────────────────────┐
│                   SERVICES                          │
│  (Logique métier globale)                           │
│  - AuthenticationService                            │
│  - FirestoreService                                 │
│  - GamificationService                              │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ Appels API/Database
                  │
┌─────────────────▼───────────────────────────────────┐
│              FIREBASE / BACKEND                     │
│  - Firebase Auth                                    │
│  - Cloud Firestore                                  │
│  - Firebase Cloud Messaging                         │
└─────────────────────────────────────────────────────┘
```

### Avantages de cette Architecture

1. **Séparation des Responsabilités**

   - Vue : Uniquement l'affichage
   - ViewModel : Logique de présentation
   - Services : Logique métier réutilisable

2. **Testabilité**

   - ViewModels testables sans UI
   - Services mockables facilement
   - Injection de dépendances facilitée

3. **Maintenabilité**
   - Code organisé et structuré
   - Facilité d'ajout de nouvelles fonctionnalités
   - Isolation des changements

---

## 📦 Structure des Packages

### Dépendances Principales

#### Firebase Suite

```yaml
firebase_core: ^3.6.0 # Core Firebase
firebase_auth: ^5.3.1 # Authentification
cloud_firestore: ^5.4.4 # Base de données NoSQL
firebase_messaging: ^15.1.3 # Notifications push
```

#### Architecture Stacked

```yaml
stacked: ^3.4.0 # Framework MVVM
stacked_services: ^1.1.0 # Services navigation, dialog, etc.
stacked_generator: ^1.3.3 # Génération de code
```

#### Sérialisation

```yaml
json_annotation: ^4.9.0 # Annotations pour JSON
json_serializable: ^6.8.0 # Génération code JSON
```

#### UI/UX

```yaml
flutter_svg: ^2.0.10+1 # Images vectorielles
google_fonts: ^6.2.1 # Polices Google
intl: ^0.19.0 # Internationalisation
```

---

## 📁 Organisation du Code Source

### Structure Détaillée

```
lib/
│
├── app/                                    # Configuration Stacked
│   ├── app.dart                           # Définition routes, services, dialogs
│   ├── app.locator.dart                   # Service locator (généré)
│   ├── app.router.dart                    # Routes navigation (généré)
│   ├── app.dialogs.dart                   # Configuration dialogs (généré)
│   └── app.bottomsheets.dart              # Configuration bottom sheets (généré)
│
├── models/                                # Modèles de données
│   ├── user_model.dart                    # Modèle utilisateur
│   │   ├── UserModel
│   │   └── user_model.g.dart (généré)
│   │
│   ├── routine_model.dart                 # Modèle routine et tâche
│   │   ├── RoutineModel
│   │   ├── TaskModel
│   │   └── routine_model.g.dart (généré)
│   │
│   └── creature_model.dart                # Modèle créature
│       ├── CreatureModel
│       ├── CreatureType (enum)
│       ├── CreatureStage (enum)
│       └── creature_model.g.dart (généré)
│
├── services/                              # Services métier
│   ├── authentication_service.dart        # Gestion auth Firebase
│   │   ├── signUpWithEmail()
│   │   ├── signInWithEmail()
│   │   ├── signOut()
│   │   └── resetPassword()
│   │
│   ├── firestore_service.dart            # Opérations Firestore
│   │   ├── User CRUD operations
│   │   ├── Routine CRUD operations
│   │   └── Creature CRUD operations
│   │
│   └── gamification_service.dart         # Logique de gamification
│       ├── completeTask()
│       ├── createStarterCreature()
│       └── calculateUserLevel()
│
└── ui/                                    # Interface utilisateur
    ├── common/                            # Composants réutilisables
    │   ├── app_colors.dart
    │   ├── app_strings.dart
    │   └── ui_helpers.dart
    │
    ├── bottom_sheets/                     # Bottom sheets
    │   └── notice/
    │
    ├── dialogs/                           # Dialogs
    │   └── info_alert/
    │
    └── views/                             # Vues principales
        ├── startup/                       # Écran splash
        │   ├── startup_view.dart
        │   └── startup_viewmodel.dart
        │
        ├── login/                         # Authentification
        │   ├── login_view.dart
        │   └── login_viewmodel.dart
        │
        ├── home/                          # Navigation principale
        │   ├── home_view.dart             # BottomNavigationBar
        │   └── home_viewmodel.dart        # IndexTrackingViewModel
        │
        ├── routines/                      # Gestion routines
        │   ├── routines_view.dart
        │   └── routines_viewmodel.dart
        │
        ├── creatures/                     # Collection créatures
        │   ├── creatures_view.dart
        │   └── creatures_viewmodel.dart
        │
        └── profile/                       # Profil utilisateur
            ├── profile_view.dart
            └── profile_viewmodel.dart
```

---

## 🔄 Flux de Données

### 1. Authentification

```
[LoginView]
    │
    ├─> User taps "Se connecter"
    │
[LoginViewModel]
    │
    ├─> Validation des inputs
    │
    └─> authService.signInWithEmail()
            │
    [AuthenticationService]
            │
            ├─> Firebase Auth API
            │
            └─> Return UserModel
                    │
            [LoginViewModel]
                    │
                    ├─> firestoreService.createUserProfile()
                    │
                    └─> navigationService.replaceWithHomeView()
```

### 2. Complétion de Tâche

```
[RoutinesView]
    │
    ├─> User completes task
    │
[RoutinesViewModel]
    │
    └─> gamificationService.completeTask()
            │
    [GamificationService]
            │
            ├─> Mark task as completed
            ├─> Get user's creature
            ├─> creature.addExperience(xp)
            │       │
            │       └─> Check level up
            │       └─> Check evolution
            │
            ├─> firestoreService.updateCreature()
            └─> firestoreService.updateUserProfile()
                    │
                    └─> UI updates via notifyListeners()
```

### 3. Chargement des Données

```
[StartupView]
    │
[StartupViewModel]
    │
    ├─> Check authService.currentUser
    │
    ├─> If authenticated:
    │   └─> Navigate to HomeView
    │
    └─> If not authenticated:
        └─> Navigate to LoginView

[HomeView]
    │
    ├─> Shows BottomNavigationBar
    │
    ├─> Tab 0: RoutinesView
    │   └─> Load user routines from Firestore
    │
    ├─> Tab 1: CreaturesView
    │   └─> Load user creatures from Firestore
    │
    └─> Tab 2: ProfileView
        └─> Load user profile + stats from Firestore
```

---

## 🗄️ Structure de la Base de Données (Firestore)

### Collections

#### 1. `users/`

```json
{
  "userId": {
    "id": "userId",
    "email": "user@example.com",
    "displayName": "John Doe",
    "totalExperience": 1500,
    "createdAt": "2025-10-31T12:00:00Z",
    "lastLogin": "2025-10-31T14:30:00Z"
  }
}
```

#### 2. `routines/`

```json
{
  "routineId": {
    "id": "routineId",
    "userId": "userId",
    "title": "Routine Matinale",
    "description": "Ma routine du matin",
    "tasks": [
      {
        "id": "task1",
        "title": "Méditation 10 min",
        "experienceReward": 15,
        "isCompleted": false,
        "completedAt": null
      }
    ],
    "createdAt": "2025-10-31T08:00:00Z",
    "updatedAt": null,
    "isActive": true
  }
}
```

#### 3. `creatures/`

```json
{
  "creatureId": {
    "id": "creatureId",
    "userId": "userId",
    "name": "Flammy",
    "type": "fire",
    "stage": "teen",
    "level": 18,
    "experience": 45,
    "experienceToNextLevel": 270,
    "obtainedAt": "2025-10-15T10:00:00Z",
    "lastFed": "2025-10-31T12:00:00Z"
  }
}
```

### Relations

```
User (1) ─────────< (N) Routines
User (1) ─────────< (N) Creatures

- Un utilisateur peut avoir plusieurs routines
- Un utilisateur peut avoir plusieurs créatures
- Chaque routine/créature appartient à un seul utilisateur
```

### Index Recommandés

```
routines:
  - userId (ASC), isActive (ASC), createdAt (DESC)

creatures:
  - userId (ASC), obtainedAt (DESC)
```

---

## 🔐 Sécurité

### Rules Firestore (Développement)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if false; // Prevent deletion
    }

    // Routines collection
    match /routines/{routineId} {
      allow read: if isAuthenticated() &&
                     resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() &&
                       request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() &&
                       resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() &&
                       resource.data.userId == request.auth.uid;
    }

    // Creatures collection
    match /creatures/{creatureId} {
      allow read: if isAuthenticated() &&
                     resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() &&
                       request.resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() &&
                       resource.data.userId == request.auth.uid;
      allow delete: if isAuthenticated() &&
                       resource.data.userId == request.auth.uid;
    }
  }
}
```

### Bonnes Pratiques de Sécurité

1. ✅ Toutes les opérations nécessitent une authentification
2. ✅ Les utilisateurs ne peuvent accéder qu'à leurs propres données
3. ✅ Validation côté serveur via rules Firestore
4. ⚠️ Ajouter validation des données (types, limites) en production
5. ⚠️ Implémenter rate limiting pour éviter les abus

---

## 🎮 Logique de Gamification

### Système d'Expérience

#### Calcul du Niveau de Créature

```dart
// Formule: XP requis = niveau × 100 × 1.5
int experienceToNextLevel(int level) {
  return (level * 100 * 1.5).round();
}

// Exemple:
// Niveau 1 → 150 XP
// Niveau 2 → 300 XP
// Niveau 10 → 1500 XP
```

#### Évolution des Créatures

```dart
// Seuils d'évolution basés sur le niveau
Niveau 1-4   : Egg (Œuf)
Niveau 5-14  : Baby (Bébé)
Niveau 15-29 : Teen (Adolescent)
Niveau 30-49 : Adult (Adulte)
Niveau 50+   : Legendary (Légendaire)
```

#### Niveau Utilisateur

```dart
// Niveau global basé sur XP totale
int userLevel = (totalExperience / 1000).floor() + 1;

// Exemple:
// 0-999 XP    : Niveau 1
// 1000-1999 XP: Niveau 2
// 5000-5999 XP: Niveau 6
```

### Récompenses par Tâche

```dart
// Valeurs par défaut
Tâche Simple    : 10 XP
Tâche Moyenne   : 15 XP
Tâche Difficile : 20 XP

// Personnalisable par l'utilisateur lors de la création
```

---

## 🔌 Services & Injection de Dépendances

### Service Locator (Get It)

```dart
@StackedApp(
  dependencies: [
    // Navigation & UI Services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),

    // Business Logic Services
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: GamificationService),
  ]
)
```

### Utilisation dans les ViewModels

```dart
class MyViewModel extends BaseViewModel {
  // Injection via locator
  final _authService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();

  // Utilisation
  Future<void> loadData() async {
    final userId = _authService.currentUser?.uid;
    final data = await _firestoreService.getUserData(userId);
  }
}
```

---

## 🧪 Stratégie de Tests (À Implémenter)

### Tests Unitaires

```dart
// ViewModels
test_routines_viewmodel_test.dart
test_creatures_viewmodel_test.dart
test_profile_viewmodel_test.dart

// Services
test_authentication_service_test.dart
test_firestore_service_test.dart
test_gamification_service_test.dart

// Models
test_user_model_test.dart
test_routine_model_test.dart
test_creature_model_test.dart
```

### Tests d'Intégration

```dart
// Flux complets
test_authentication_flow_test.dart
test_routine_completion_flow_test.dart
test_creature_evolution_flow_test.dart
```

### Tests UI (Golden Tests)

```dart
// Snapshots visuels
golden_login_view_test.dart
golden_routines_view_test.dart
golden_creatures_view_test.dart
```

---

## 🚀 Déploiement

### Environnements

#### Développement

- Firebase Project: `moongo-dev`
- Build Mode: Debug
- API Keys: Dev keys

#### Staging

- Firebase Project: `moongo-staging`
- Build Mode: Profile
- API Keys: Staging keys

#### Production

- Firebase Project: `moongo-prod`
- Build Mode: Release
- API Keys: Production keys

### Configuration par Environnement

```dart
// lib/config/environment.dart
enum Environment { dev, staging, prod }

class AppConfig {
  static Environment current = Environment.dev;

  static String get firebaseProjectId {
    switch (current) {
      case Environment.dev:
        return 'moongo-dev';
      case Environment.staging:
        return 'moongo-staging';
      case Environment.prod:
        return 'moongo-prod';
    }
  }
}
```

---

## 📈 Métriques & Analytics (Futur)

### Firebase Analytics Events

```dart
// User Events
- user_signup
- user_login
- user_logout

// Routine Events
- routine_created
- routine_completed
- task_completed

// Creature Events
- creature_obtained
- creature_evolved
- creature_level_up

// Engagement
- daily_active_user
- session_duration
- feature_usage
```

### Crashlytics

```dart
// Automatic crash reporting
- Fatal errors
- Non-fatal exceptions
- Custom logs
- User identification
```

---

## ⚡ Performance

### Optimisations Implémentées

1. **Lazy Loading**

   - Services créés uniquement à la demande
   - ViewModels instantanés

2. **Caching**

   - Firestore cache local activé
   - Données en mémoire dans les ViewModels

3. **Pagination** (À implémenter)
   - Chargement progressif des routines
   - Limite de résultats Firestore

### Optimisations Futures

- Images optimisées (compression, cache)
- Lazy loading des créatures
- Debouncing des recherches
- Offline-first avec synchronisation

---

## 🔮 Évolutions Prévues

### Phase 2 - Fonctionnalités Avancées

- [ ] Notifications push
- [ ] Rappels intelligents
- [ ] Système de badges
- [ ] Graphiques de progression
- [ ] Mode hors ligne complet
- [ ] Personnalisation créatures

### Phase 3 - Social

- [ ] Profils publics
- [ ] Partage de routines
- [ ] Classements
- [ ] Défis entre amis
- [ ] Communauté

### Phase 4 - Monétisation

- [ ] Créatures premium
- [ ] Thèmes personnalisés
- [ ] Suppression publicités
- [ ] Fonctionnalités exclusives

---

## 🐛 Limitations Actuelles

### Techniques

- ❌ Pas de gestion d'erreurs robuste
- ❌ Pas de retry logic pour les appels réseau
- ❌ Pas de pagination
- ❌ Pas de cache persistant
- ❌ Pas de mode offline

### Fonctionnelles

- ❌ Création de routine basique uniquement
- ❌ Pas de modification de routine
- ❌ Pas de suppression de tâche
- ❌ Pas de statistiques détaillées
- ❌ Pas de personnalisation créatures

### UX/UI

- ❌ Design minimal (placeholder)
- ❌ Pas d'animations
- ❌ Pas de feedback visuel avancé
- ❌ Pas de tutoriel
- ❌ Pas d'onboarding

---

## 📚 Ressources & Documentation

### Documentation Officielle

- [Flutter](https://docs.flutter.dev/)
- [Firebase](https://firebase.google.com/docs)
- [Stacked](https://pub.dev/packages/stacked)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)

### Packages Utilisés

- [firebase_core](https://pub.dev/packages/firebase_core)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [stacked](https://pub.dev/packages/stacked)
- [stacked_services](https://pub.dev/packages/stacked_services)
- [json_serializable](https://pub.dev/packages/json_serializable)

---

## 👥 Contribution

### Convention de Nommage

```dart
// Files
snake_case: user_model.dart, authentication_service.dart

// Classes
PascalCase: UserModel, AuthenticationService

// Variables & Functions
camelCase: userName, getUserProfile()

// Constants
SCREAMING_SNAKE_CASE: MAX_RETRIES, DEFAULT_TIMEOUT

// Private members
_prefixedCamelCase: _privateVariable, _privateMethod()
```

### Structure de Commit

```
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore
Scopes: auth, firestore, ui, models, services

Exemples:
feat(auth): add password reset functionality
fix(firestore): resolve user profile loading issue
docs(readme): update setup instructions
```

---

## 📝 Changelog

### Version 0.1.0 (31 Oct 2025) - Squelette Initial

- ✅ Architecture MVVM avec Stacked
- ✅ Configuration Firebase
- ✅ Services de base (Auth, Firestore, Gamification)
- ✅ Modèles de données (User, Routine, Creature)
- ✅ Vues principales (Login, Home, Routines, Creatures, Profile)
- ✅ Navigation avec BottomNavigationBar
- ✅ Système d'expérience et évolution

---

**Document créé le** : 31 octobre 2025  
**Dernière mise à jour** : 31 octobre 2025  
**Version** : 1.0  
**Auteur** : AI Assistant
