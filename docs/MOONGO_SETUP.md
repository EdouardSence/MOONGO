# MOONGO - Guide de Configuration

## 📱 Description du Projet

MOONGO est une application mobile de gestion de routines avec un système de gamification. Les utilisateurs peuvent :

- Créer et gérer des routines quotidiennes
- Compléter des tâches pour gagner de l'expérience
- Faire évoluer des créatures grâce aux points gagnés
- Suivre leur progression avec des statistiques

## 🏗️ Architecture de l'Application

### Structure des Dossiers

```
lib/
├── app/                          # Configuration Stacked (routes, services)
├── models/                       # Modèles de données
│   ├── user_model.dart          # Modèle utilisateur
│   ├── routine_model.dart       # Modèle routine et tâche
│   └── creature_model.dart      # Modèle créature
├── services/                    # Services métier
│   ├── authentication_service.dart
│   ├── firestore_service.dart
│   └── gamification_service.dart
└── ui/
    └── views/                   # Vues de l'application
        ├── startup/             # Écran de démarrage
        ├── login/               # Connexion/Inscription
        ├── home/                # Navigation principale
        ├── routines/            # Liste des routines
        ├── creatures/           # Liste des créatures
        └── profile/             # Profil utilisateur
```

## 🔧 Configuration Firebase

### Étape 1 : Créer un Projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquez sur "Ajouter un projet"
3. Nommez votre projet "MOONGO" (ou autre nom)
4. Suivez les étapes de création

### Étape 2 : Configurer Firebase Authentication

1. Dans la console Firebase, allez dans **Authentication**
2. Cliquez sur **Commencer**
3. Activez le fournisseur **Email/Password**
4. Sauvegardez

### Étape 3 : Configurer Cloud Firestore

1. Dans la console Firebase, allez dans **Firestore Database**
2. Cliquez sur **Créer une base de données**
3. Choisissez le mode **Test** pour commencer (⚠️ à sécuriser en production)
4. Choisissez une région (ex: europe-west1)

#### Règles de sécurité Firestore (temporaires pour le développement)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Utilisateurs peuvent lire/écrire leurs propres données
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Routines appartiennent aux utilisateurs
    match /routines/{routineId} {
      allow read, write: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }

    // Créatures appartiennent aux utilisateurs
    match /creatures/{creatureId} {
      allow read, write: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }
  }
}
```

### Étape 4 : Ajouter l'Application Android

1. Dans la console Firebase, cliquez sur l'icône Android
2. Entrez le package name : `com.example.my_first_app` (ou votre package)
3. Téléchargez le fichier `google-services.json`
4. Remplacez le fichier `android/app/google-services.json` par celui téléchargé

### Étape 5 : Configurer Android Build

Modifiez `android/build.gradle.kts` pour ajouter le plugin Google Services :

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.0" apply false
}
```

Modifiez `android/app/build.gradle.kts` pour appliquer le plugin :

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}
```

### Étape 6 : Configurer iOS (Optionnel)

1. Dans la console Firebase, cliquez sur l'icône iOS
2. Entrez le Bundle ID : `com.example.myFirstApp`
3. Téléchargez le fichier `GoogleService-Info.plist`
4. Ajoutez-le dans `ios/Runner/` via Xcode

### Étape 7 : Firebase Cloud Messaging (Futur)

Pour les notifications push :

1. Allez dans **Cloud Messaging** dans Firebase
2. Configurez les certificats iOS et la clé serveur Android
3. Cette étape sera nécessaire pour implémenter les rappels de routines

## 📦 Dépendances Installées

```yaml
# Firebase
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.4
firebase_messaging: ^15.1.3

# Architecture Stacked
stacked: ^3.4.0
stacked_services: ^1.1.0

# UI & Utils
flutter_svg: ^2.0.10+1
google_fonts: ^6.2.1
intl: ^0.19.0

# Serialization
json_annotation: ^4.9.0
json_serializable: ^6.8.0

# Code Generation
build_runner: ^2.4.5
stacked_generator: ^1.3.3
```

## 🎮 Système de Gamification

### Types de Créatures

1. **Fire** (Feu) - Couleur rouge
2. **Water** (Eau) - Couleur bleue
3. **Earth** (Terre) - Couleur marron
4. **Air** (Air) - Couleur cyan
5. **Nature** (Nature) - Couleur verte

### Stades d'Évolution

1. **Egg** (Œuf) - Niveau 1-4
2. **Baby** (Bébé) - Niveau 5-14
3. **Teen** (Adolescent) - Niveau 15-29
4. **Adult** (Adulte) - Niveau 30-49
5. **Legendary** (Légendaire) - Niveau 50+

### Système d'Expérience

- Chaque tâche complétée rapporte des points d'expérience (XP)
- XP par défaut : 10 points par tâche
- Formule de niveau : `XP requis = niveau × 100 × 1.5`
- L'utilisateur accumule également l'XP totale
- Niveau utilisateur = `(XP totale / 1000) + 1`

## 🚀 Commandes Utiles

### Installer les dépendances

```bash
flutter pub get
```

### Générer le code (routes, locator, json)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Lancer l'application

```bash
flutter run
```

### Lancer sur un émulateur spécifique

```bash
flutter run -d <device-id>
```

### Nettoyer le build

```bash
flutter clean
flutter pub get
```

## 📝 Modèles de Données

### UserModel

```dart
{
  id: String
  email: String
  displayName: String?
  totalExperience: int
  createdAt: DateTime
  lastLogin: DateTime?
}
```

### RoutineModel

```dart
{
  id: String
  userId: String
  title: String
  description: String?
  tasks: List<TaskModel>
  createdAt: DateTime
  updatedAt: DateTime?
  isActive: bool
}
```

### TaskModel

```dart
{
  id: String
  title: String
  experienceReward: int
  isCompleted: bool
  completedAt: DateTime?
}
```

### CreatureModel

```dart
{
  id: String
  userId: String
  name: String
  type: CreatureType (fire, water, earth, air, nature)
  stage: CreatureStage (egg, baby, teen, adult, legendary)
  level: int
  experience: int
  experienceToNextLevel: int
  obtainedAt: DateTime
  lastFed: DateTime?
}
```

## 🔄 Prochaines Étapes

### MVP (Version 1.0)

- [x] Architecture de base avec Stacked
- [x] Authentification Firebase
- [x] Modèles de données
- [x] Services Firebase
- [x] Interface de connexion
- [x] Navigation principale
- [x] Vue des routines
- [x] Vue des créatures
- [x] Vue du profil
- [ ] Création de routines fonctionnelle
- [ ] Complétion de tâches
- [ ] Attribution d'XP aux créatures
- [ ] Système d'évolution automatique
- [ ] Tests unitaires

### Version 2.0 (Fonctionnalités avancées)

- [ ] Notifications push (Firebase Cloud Messaging)
- [ ] Rappels de routines
- [ ] Système de badges/trophées
- [ ] Statistiques détaillées avec graphiques
- [ ] Personnalisation des créatures
- [ ] Thème sombre
- [ ] Animations d'évolution
- [ ] Sons et effets visuels

### Version 3.0 (Social)

- [ ] Profils publics
- [ ] Partage de routines
- [ ] Classements
- [ ] Système d'amis
- [ ] Défis communautaires

## 🎨 Design

### Palette de Couleurs (Actuelle - Simple)

- Primaire : Deep Purple
- Secondaire : Couleurs selon type de créature
- Background : Blanc/Gris clair

### Future Palette (Cartoon/Mignon)

- À définir selon l'identité visuelle

## ⚠️ Notes Importantes

1. **Sécurité** : Les règles Firestore actuelles sont en mode développement. À sécuriser pour la production.
2. **Firebase Config** : Le fichier `google-services.json` contient des placeholders. Remplacez-le par le vrai fichier.
3. **Code Generation** : Relancez `build_runner` après chaque modification des modèles ou routes.
4. **Tests** : Aucun test n'a été créé pour le moment - à ajouter.

## 📞 Support

Pour toute question sur la configuration ou le développement, référez-vous à :

- [Documentation Flutter](https://docs.flutter.dev/)
- [Documentation Firebase](https://firebase.google.com/docs)
- [Documentation Stacked](https://pub.dev/packages/stacked)

---

**Créé le** : 31 octobre 2025
**Version** : 0.1.0 (Squelette)
