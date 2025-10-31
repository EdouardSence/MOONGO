import 'package:stacked/stacked.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/firestore_service.dart';
import 'package:my_first_app/models/routine_model.dart';

class RoutinesViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();

  List<RoutineModel> _routines = [];
  List<RoutineModel> get routines => _routines;

  Future<void> initialize() async {
    await loadRoutines();
  }

  Future<void> loadRoutines() async {
    try {
      setBusy(true);
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        _routines = await _firestoreService.getUserRoutines(userId);
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> createRoutine() async {
    // TODO: Ouvrir un dialog ou une nouvelle page pour créer une routine
    // Pour l'instant, créer une routine simple de démonstration
    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        final newRoutine = RoutineModel(
          id: '',
          userId: userId,
          title: 'Nouvelle Routine',
          description: 'Description de la routine',
          tasks: [
            TaskModel(id: '1', title: 'Tâche 1', experienceReward: 10),
            TaskModel(id: '2', title: 'Tâche 2', experienceReward: 15),
            TaskModel(id: '3', title: 'Tâche 3', experienceReward: 20),
          ],
          createdAt: DateTime.now(),
        );

        await _firestoreService.createRoutine(newRoutine);
        await loadRoutines();
      }
    } catch (e) {
      setError(e.toString());
    }
  }

  void viewRoutineDetails(String routineId) {
    // TODO: Naviguer vers la page de détails de la routine
  }
}
