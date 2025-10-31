# MOONGO - Liste des Tâches

## 📋 Projet Académique - Consignes Obligatoires

### ✅ Architecture & Configuration (COMPLÉTÉ)

- [x] Configurer architecture Stacked (MVVM) ✓
- [x] Créer modèles de données (User, Routine, Creature) ✓
- [x] Créer services de base ✓
- [x] Créer vues de base (Startup, Home, Routines, Creatures, Profile) ✓
- [x] Configuration navigation avec Stacked Router ✓
- [x] Génération de code ✓
- [x] Résoudre problèmes de cache Gradle ✓
- [x] Premier lancement de l'application réussi! 🎉

### 🎯 Priorité 1 - Consignes Obligatoires du Projet

#### ✅ Requis Minimum (À COMPLÉTER POUR LE RENDU)

- [ ] **Architecture & State Management**

  - [x] Utilisation de Stacked (✓ déjà implémenté)
  - [x] Structure MVVM respectée (✓ déjà implémenté)
  - [ ] Vérifier que tous les ViewModels utilisent BaseViewModel
  - [ ] Documenter l'architecture dans le README

- [ ] **Écrans (Minimum 2 écrans)**

  - [x] Écran 1: Home avec navigation (✓ déjà implémenté)
  - [x] Écran 2: Routines (✓ déjà implémenté)
  - [x] Écran 3: Créatures (✓ bonus - déjà implémenté)
  - [x] Écran 4: Profil (✓ bonus - déjà implémenté)
  - [ ] Navigation entre écrans avec Navigator (via Stacked Router)

- [ ] **API REST avec DIO/HTTP**

  - [ ] Installer package DIO
  - [ ] Créer service API pour récupérer des données
  - [ ] Choisir une API publique (exemples ci-dessous)
  - [ ] Implémenter au moins 1 endpoint GET
  - [ ] Afficher les données récupérées dans l'interface
  - [ ] Gérer les erreurs réseau
  - [ ] Ajouter un loading indicator pendant les requêtes

- [ ] **ThemeData et Style Global**

  - [ ] Créer un fichier theme.dart
  - [ ] Définir ThemeData pour le thème clair
  - [ ] Appliquer le thème dans MaterialApp
  - [ ] Utiliser les couleurs du thème dans toute l'app
  - [ ] Documentation du système de thème

- [ ] **Tests sur Téléphone Physique**
  - [x] Application testée sur téléphone Android (✓ déjà fait)
  - [ ] Capturer des screenshots de l'app en fonctionnement
  - [ ] Vérifier que toutes les fonctionnalités marchent sur device
  - [ ] Tester la rotation d'écran
  - [ ] Tester les performances

#### 🌟 Bonus (Recommandé)

- [ ] **Dark Mode**

  - [ ] Créer ThemeData pour le thème sombre
  - [ ] Implémenter un switch pour changer de thème
  - [ ] Persister le choix du thème (shared_preferences)
  - [ ] Animations de transition entre thèmes

- [ ] **Fonctionnalités Avancées**
  - [ ] Pagination pour les listes
  - [ ] Pull-to-refresh
  - [ ] Recherche/Filtrage
  - [ ] Animations Flutter
  - [ ] Cache local des données API

---

## 💡 Suggestions d'APIs Publiques (Choisir UNE)

### Option 1: PokéAPI (Recommandé - Facile)

- **URL**: https://pokeapi.co/
- **Documentation**: https://pokeapi.co/docs/v2
- **Utilisation pour MOONGO**: Récupérer des créatures Pokémon comme "créatures" de l'app
- **Exemples d'endpoints**:
  - GET https://pokeapi.co/api/v2/pokemon?limit=20
  - GET https://pokeapi.co/api/v2/pokemon/{id}

### Option 2: REST Countries (Facile)

- **URL**: https://restcountries.com/
- **Utilisation**: Liste de pays avec drapeaux, population, etc.

### Option 3: JSONPlaceholder (Très simple)

- **URL**: https://jsonplaceholder.typicode.com/
- **Utilisation**: Données de test (posts, users, comments)

### Option 4: OpenWeatherMap (Nécessite clé API gratuite)

- **URL**: https://openweathermap.org/api
- **Utilisation**: Météo pour gamifier les routines

### Option 5: Marvel API (Nécessite clé API)

- **URL**: https://developer.marvel.com/
- **Utilisation**: Personnages Marvel comme créatures

---

## 🎯 Plan de Développement Simplifié pour le Rendu

### Phase 1: Configuration API (2-3h)

- [ ] **Choisir l'API**

  - [ ] Lire la documentation de l'API choisie
  - [ ] Tester les endpoints avec Postman/Insomnia
  - [ ] Noter les endpoints à utiliser

- [ ] **Installer DIO**

  ```yaml
  dependencies:
    dio: ^5.4.0
  ```

  - [ ] Ajouter DIO dans pubspec.yaml
  - [ ] Run flutter pub get

- [ ] **Créer Service API**

  - [ ] Créer `lib/services/api_service.dart`
  - [ ] Initialiser DIO avec baseUrl
  - [ ] Créer méthode fetchCreatures() ou équivalent
  - [ ] Gérer les erreurs (try-catch)
  - [ ] Enregistrer dans locator

- [ ] **Créer Modèles depuis API**
  - [ ] Analyser la réponse JSON de l'API
  - [ ] Créer modèles Dart correspondants
  - [ ] Ajouter fromJson() et toJson()
  - [ ] (Bonus) Utiliser json_serializable

### Phase 2: Interface & ThemeData (2-3h)

- [ ] **Configurer ThemeData**

  - [ ] Créer `lib/ui/common/app_theme.dart`
  - [ ] Définir couleurs primaires et secondaires
  - [ ] Configurer TextTheme
  - [ ] Configurer AppBarTheme, CardTheme, etc.
  - [ ] Appliquer dans MaterialApp

- [ ] **Améliorer les Écrans Existants**

  - [ ] Modifier RoutinesView pour afficher données de l'API
  - [ ] Modifier CreaturesView pour afficher données de l'API
  - [ ] Ajouter loading states
  - [ ] Ajouter gestion d'erreurs
  - [ ] Améliorer le design avec le thème

- [ ] **Écran de Détails**
  - [ ] Créer DetailView pour afficher détails d'un élément
  - [ ] Implémenter navigation vers cet écran
  - [ ] Afficher toutes les infos de l'API
  - [ ] Ajouter bouton retour

### Phase 3: Dark Mode (Bonus - 1-2h)

- [ ] **Implémenter Dark Theme**
  - [ ] Créer darkThemeData dans app_theme.dart
  - [ ] Créer ThemeService pour gérer le thème
  - [ ] Ajouter toggle dans ProfileView
  - [ ] Sauvegarder préférence avec shared_preferences
  - [ ] Animations de transition

### Phase 4: Polissage & Tests (1-2h)

- [ ] **Tests & Optimisation**

  - [ ] Tester sur téléphone physique
  - [ ] Corriger les bugs
  - [ ] Vérifier toutes les consignes
  - [ ] Prendre screenshots
  - [ ] Optimiser les performances

- [ ] **Documentation**
  - [ ] Mettre à jour README avec:
    - Description du projet
    - API utilisée
    - Architecture
    - Screenshots
    - Instructions d'installation
  - [ ] Commenter le code important
  - [ ] Créer ARCHITECTURE.md si nécessaire

---

## 📦 Dépendances Minimales Requises

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  stacked: ^3.4.3
  stacked_services: ^1.2.0

  # Navigation
  auto_route: ^7.8.4 # ou stacked déjà configuré

  # API & Network
  dio: ^5.4.0

  # UI
  flutter_svg: ^2.0.9 # si besoin d'icônes SVG

  # Bonus Dark Mode
  shared_preferences: ^2.2.2 # pour persister le thème

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code generation
  build_runner: ^2.4.7
  stacked_generator: ^1.5.0
  json_serializable: ^6.7.1 # si utilisation
```

---

## 🔥 Priorité 2 - Retirer Firebase (Simplifier pour le Rendu)

### À RETIRER OU DÉSACTIVER

- [ ] **Firebase (Non requis pour le projet)**

- [ ] **Créer projet Firebase**

  - [ ] Aller sur Firebase Console
  - [ ] Créer nouveau projet "MOONGO"
  - [ ] Activer Firebase Authentication
  - [ ] Activer Cloud Firestore
  - [ ] Configurer règles de sécurité Firestore

- [ ] **Configurer Android**

  - [ ] Ajouter app Android dans Firebase
  - [ ] Télécharger google-services.json
  - [ ] Remplacer le fichier placeholder
  - [ ] Ajouter plugin Google Services dans build.gradle

- [ ] **Configurer iOS** (Optionnel pour démarrer)

  - [ ] Ajouter app iOS dans Firebase
  - [ ] Télécharger GoogleService-Info.plist
  - [ ] Ajouter dans Xcode

- [ ] **Tester la configuration**
  - [ ] Lancer l'app en mode debug
  - [ ] Tester la connexion Firebase
  - [ ] Créer un compte de test

### 🎨 Priorité 2 - Fonctionnalités de Création

- [ ] **Création de Routines**

  - [ ] Dialog/Page pour créer une nouvelle routine
  - [ ] Formulaire : titre, description
  - [ ] Ajouter/Supprimer des tâches
  - [ ] Définir XP par tâche
  - [ ] Sauvegarder dans Firestore
  - [ ] Validation des inputs

- [ ] **Gestion des Routines**

  - [ ] Afficher la liste des routines
  - [ ] Voir les détails d'une routine
  - [ ] Modifier une routine existante
  - [ ] Supprimer une routine (soft delete)
  - [ ] Dupliquer une routine

- [ ] **Détails d'une Routine**
  - [ ] Vue détaillée avec toutes les tâches
  - [ ] Checkbox pour cocher/décocher les tâches
  - [ ] Barre de progression
  - [ ] Bouton "Réinitialiser" (pour routines quotidiennes)

### 🐾 Priorité 3 - Système de Créatures

- [ ] **Création de la première créature**

  - [ ] Onboarding : choisir type de créature
  - [ ] Nommer sa créature
  - [ ] Créer créature de départ (niveau 1, œuf)
  - [ ] Sauvegarder dans Firestore

- [ ] **Évolution automatique**

  - [ ] Détecter changement de niveau
  - [ ] Détecter changement de stage
  - [ ] Animation/Dialog d'évolution
  - [ ] Notification de level up

- [ ] **Collection de créatures**
  - [ ] Afficher toutes les créatures
  - [ ] Filtrer par type/stage
  - [ ] Trier par niveau/date
  - [ ] Détails d'une créature

### ⚡ Priorité 4 - Complétion de Tâches

- [ ] **Workflow de complétion**

  - [ ] Cocher une tâche
  - [ ] Sélectionner la créature à nourrir
  - [ ] Appeler gamificationService.completeTask()
  - [ ] Mettre à jour UI en temps réel
  - [ ] Afficher feedback (+XP animation)

- [ ] **Gestion des tâches quotidiennes**
  - [ ] Réinitialisation automatique à minuit
  - [ ] Cloud Function ou job local
  - [ ] Historique des complétions
  - [ ] Streaks (séries de jours consécutifs)

### 📊 Priorité 5 - Statistiques

- [ ] **Profil utilisateur**

  - [ ] Afficher niveau global
  - [ ] Afficher XP totale
  - [ ] Nombre de créatures
  - [ ] Nombre de routines actives
  - [ ] Tâches complétées aujourd'hui

- [ ] **Graphiques simples**
  - [ ] XP gagnée par jour (7 derniers jours)
  - [ ] Taux de complétion des routines
  - [ ] Créatures par type (pie chart)

### 🧪 Priorité 6 - Tests & Qualité

- [ ] **Tests unitaires**

  - [ ] Tests des ViewModels
  - [ ] Tests des Services
  - [ ] Tests des Modèles (méthodes)
  - [ ] Mock de Firebase

- [ ] **Gestion d'erreurs**

  - [ ] Try-catch robustes
  - [ ] Messages d'erreur utilisateur-friendly
  - [ ] Logging des erreurs
  - [ ] Retry logic pour réseau

- [ ] **Validation**
  - [ ] Validation des formulaires
  - [ ] Contraintes Firestore
  - [ ] Limites (max routines, max créatures)

---

## 🚀 Version 2.0 - Fonctionnalités Avancées

### 🔔 Notifications Push

- [ ] **Configuration Firebase Cloud Messaging**

  - [ ] Configurer FCM dans Firebase
  - [ ] Demander permissions notifications
  - [ ] Gérer les tokens FCM
  - [ ] Tester notifications locales

- [ ] **Rappels de routines**
  - [ ] Planifier notifications quotidiennes
  - [ ] Personnaliser heure de rappel
  - [ ] Types de rappels (matin, soir, custom)
  - [ ] Désactiver/Activer rappels

### 🏆 Système de Badges/Trophées

- [ ] **Définir badges**

  - [ ] Premier niveau atteint
  - [ ] Première créature évoluée
  - [ ] 7 jours de streak
  - [ ] 30 jours de streak
  - [ ] 100 tâches complétées
  - [ ] 10 créatures obtenues

- [ ] **Implémentation**
  - [ ] Modèle Badge/Achievement
  - [ ] Logique de déverrouillage
  - [ ] UI d'affichage
  - [ ] Notifications de déblocage

### 📈 Statistiques Avancées

- [ ] **Graphiques détaillés**

  - [ ] XP par semaine/mois
  - [ ] Taux de complétion par routine
  - [ ] Meilleurs jours de la semaine
  - [ ] Progression niveau créatures

- [ ] **Insights**
  - [ ] Routines les plus suivies
  - [ ] Temps moyen de complétion
  - [ ] Suggestions d'amélioration

### 🎨 UI/UX Améliorés

- [ ] **Design cartoon/mignon**

  - [ ] Illustrations de créatures personnalisées
  - [ ] Palette de couleurs définitive
  - [ ] Iconographie cohérente
  - [ ] Typographie

- [ ] **Animations**

  - [ ] Animation d'évolution
  - [ ] Animation level up
  - [ ] Transitions de pages
  - [ ] Feedback visuel (tap, swipe)

- [ ] **Personnalisation**
  - [ ] Thème sombre
  - [ ] Couleurs personnalisables
  - [ ] Avatars de créatures
  - [ ] Backgrounds personnalisés

### 🌐 Mode Offline

- [ ] **Cache persistant**
  - [ ] Stocker données localement (Hive/SQLite)
  - [ ] Synchronisation en arrière-plan
  - [ ] Indicator de connexion
  - [ ] Queue d'actions offline

---

## 🌟 Version 3.0 - Social & Communauté

### 👥 Fonctionnalités Sociales

- [ ] **Profils publics**

  - [ ] Username unique
  - [ ] Avatar
  - [ ] Bio
  - [ ] Statistiques publiques
  - [ ] Créatures en vitrine

- [ ] **Système d'amis**

  - [ ] Rechercher utilisateurs
  - [ ] Ajouter/Supprimer amis
  - [ ] Liste d'amis
  - [ ] Voir profils amis

- [ ] **Classements**
  - [ ] Leaderboard global (XP)
  - [ ] Leaderboard amis
  - [ ] Leaderboard hebdomadaire
  - [ ] Leaderboard par type de créature

### 🔄 Partage de Contenu

- [ ] **Partager routines**

  - [ ] Rendre routine publique
  - [ ] Browse routines publiques
  - [ ] Importer routine d'un autre user
  - [ ] Noter/Commenter routines

- [ ] **Défis**
  - [ ] Créer un défi
  - [ ] Inviter amis à un défi
  - [ ] Suivre progression défi
  - [ ] Récompenses de défi

---

## 💰 Version 4.0 - Monétisation (Optionnel)

### 💎 Premium Features

- [ ] **Créatures exclusives**

  - [ ] Types de créatures premium
  - [ ] Évolutions spéciales
  - [ ] Animations exclusives

- [ ] **Fonctionnalités premium**
  - [ ] Routines illimitées (vs limite gratuit)
  - [ ] Statistiques avancées
  - [ ] Thèmes premium
  - [ ] Pas de publicités

### 🛒 In-App Purchases

- [ ] **Configuration**
  - [ ] Google Play Billing
  - [ ] Apple In-App Purchase
  - [ ] Produits consommables
  - [ ] Abonnements

---

## 🔧 Améliorations Techniques

### Performance

- [ ] Lazy loading des images
- [ ] Pagination Firestore
- [ ] Debouncing recherches
- [ ] Cache images
- [ ] Optimisation build size

### Sécurité

- [ ] Règles Firestore production
- [ ] Rate limiting
- [ ] Validation backend (Cloud Functions)
- [ ] Encryption données sensibles
- [ ] HTTPS uniquement

### DevOps

- [ ] CI/CD (GitHub Actions)
- [ ] Tests automatisés
- [ ] Déploiement automatique
- [ ] Environnements (dev, staging, prod)
- [ ] Monitoring (Crashlytics, Analytics)

---

## 📱 Plateformes

### Android

- [x] Configuration de base
- [ ] Tests sur devices physiques
- [ ] Optimisation Android
- [ ] Publication Google Play

### iOS

- [ ] Configuration complète
- [ ] Tests sur devices physiques
- [ ] Optimisation iOS
- [ ] Publication App Store

### Web (Futur)

- [ ] Responsive design
- [ ] PWA features
- [ ] Déploiement Firebase Hosting

---

## 📝 Documentation

- [x] README initial
- [x] Guide de configuration (MOONGO_SETUP.md)
- [x] Rapport d'architecture (ARCHITECTURE_REPORT.md)
- [ ] Documentation API
- [ ] Guide utilisateur
- [ ] Tutoriels vidéo
- [ ] FAQ

---

## 🎓 Apprentissage & Recherche

- [ ] Rechercher meilleures pratiques gamification
- [ ] Étudier apps similaires (Habitica, Forest)
- [ ] UX research (interviews utilisateurs)
- [ ] A/B testing features

---

**Dernière mise à jour** : 31 octobre 2025  
**Prochaine priorité** : Configuration Firebase
