import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_first_app/models/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Stream de l'utilisateur connecté
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Utilisateur actuellement connecté
  User? get currentUser => _firebaseAuth.currentUser;

  /// Inscription avec email et mot de passe
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }

        return UserModel(
          id: user.uid,
          email: user.email!,
          displayName: displayName ?? user.displayName,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Connexion avec email et mot de passe
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName,
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          lastLogin: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Gestion des exceptions d'authentification
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'weak-password':
          return 'Le mot de passe est trop faible.';
        case 'email-already-in-use':
          return 'Un compte existe déjà avec cet email.';
        case 'user-not-found':
          return 'Aucun utilisateur trouvé avec cet email.';
        case 'wrong-password':
          return 'Mot de passe incorrect.';
        case 'invalid-email':
          return 'Email invalide.';
        case 'user-disabled':
          return 'Ce compte a été désactivé.';
        case 'too-many-requests':
          return 'Trop de tentatives. Réessayez plus tard.';
        default:
          return 'Erreur d\'authentification: ${e.message}';
      }
    }
    return 'Une erreur inattendue s\'est produite.';
  }
}
