import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_first_app/models/user_model.dart';
import 'package:my_first_app/models/routine_model.dart';
import 'package:my_first_app/models/creature_model.dart';

class FirestoreService {
  FirebaseFirestore? _firestoreInstance;

  /// Lazy initialization de Firestore
  FirebaseFirestore? get _firestoreNullable {
    try {
      _firestoreInstance ??= FirebaseFirestore.instance;
      return _firestoreInstance;
    } catch (e) {
      print('⚠️ Firestore non disponible: $e');
      return null;
    }
  }

  /// Get Firestore instance or throw if not available
  FirebaseFirestore get _firestore {
    final instance = _firestoreNullable;
    if (instance == null) {
      throw Exception(
          'Firestore n\'est pas configuré. Veuillez configurer Firebase.');
    }
    return instance;
  }

  // Collections
  static const String usersCollection = 'users';
  static const String routinesCollection = 'routines';
  static const String creaturesCollection = 'creatures';

  // ========== USER OPERATIONS ==========

  /// Créer un profil utilisateur
  Future<void> createUserProfile(UserModel user) async {
    await _firestore
        .collection(usersCollection)
        .doc(user.id)
        .set(user.toJson());
  }

  /// Récupérer un profil utilisateur
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore.collection(usersCollection).doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  /// Mettre à jour un profil utilisateur
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    await _firestore.collection(usersCollection).doc(userId).update(data);
  }

  /// Stream du profil utilisateur
  Stream<UserModel?> userProfileStream(String userId) {
    return _firestore.collection(usersCollection).doc(userId).snapshots().map(
          (doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null,
        );
  }

  // ========== ROUTINE OPERATIONS ==========

  /// Créer une routine
  Future<String> createRoutine(RoutineModel routine) async {
    final docRef =
        await _firestore.collection(routinesCollection).add(routine.toJson());
    return docRef.id;
  }

  /// Récupérer les routines d'un utilisateur
  Future<List<RoutineModel>> getUserRoutines(String userId) async {
    final querySnapshot = await _firestore
        .collection(routinesCollection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => RoutineModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Stream des routines d'un utilisateur
  Stream<List<RoutineModel>> userRoutinesStream(String userId) {
    return _firestore
        .collection(routinesCollection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RoutineModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Mettre à jour une routine
  Future<void> updateRoutine(
      String routineId, Map<String, dynamic> data) async {
    await _firestore.collection(routinesCollection).doc(routineId).update(data);
  }

  /// Supprimer une routine (soft delete)
  Future<void> deleteRoutine(String routineId) async {
    await _firestore.collection(routinesCollection).doc(routineId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ========== CREATURE OPERATIONS ==========

  /// Créer une créature
  Future<String> createCreature(CreatureModel creature) async {
    final docRef =
        await _firestore.collection(creaturesCollection).add(creature.toJson());
    return docRef.id;
  }

  /// Récupérer les créatures d'un utilisateur
  Future<List<CreatureModel>> getUserCreatures(String userId) async {
    final querySnapshot = await _firestore
        .collection(creaturesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('obtainedAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => CreatureModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Stream des créatures d'un utilisateur
  Stream<List<CreatureModel>> userCreaturesStream(String userId) {
    return _firestore
        .collection(creaturesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('obtainedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CreatureModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  /// Mettre à jour une créature
  Future<void> updateCreature(String creatureId, CreatureModel creature) async {
    await _firestore
        .collection(creaturesCollection)
        .doc(creatureId)
        .update(creature.toJson());
  }

  /// Supprimer une créature
  Future<void> deleteCreature(String creatureId) async {
    await _firestore.collection(creaturesCollection).doc(creatureId).delete();
  }
}
