import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_first_app/app/app.bottomsheets.dart';
import 'package:my_first_app/app/app.dialogs.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase (avec gestion d'erreur)
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialisé avec succès');
  } catch (e) {
    debugPrint('⚠️ Firebase non configuré: $e');
    debugPrint('💡 L\'application fonctionnera en mode démo sans Firebase');
  }

  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOONGO',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
    );
  }
}
