import 'package:firebase_auth/firebase_auth.dart';

/// Service de gestion de l'authentification
/// Centralise toutes les opérations Firebase Auth
class AuthenticationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Récupère l'utilisateur actuellement connecté (PERSISTANT)
  User? get currentUser => firebaseAuth.currentUser;

  // Stream pour écouter les changements d'état d'auth (comme onAuthStateChanged en RN)
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Vérifie si un utilisateur est connecté
  bool get isLoggedIn => currentUser != null;

  // Email de l'utilisateur connecté
  String? get userEmail => currentUser?.email;

  // ID de l'utilisateur connecté
  String? get userId => currentUser?.uid;

  // Inscription avec email/password
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Connexion avec email/password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Déconnexion
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Rafraîchir les données de l'utilisateur
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  // Envoyer un email de vérification
  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  // Réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
