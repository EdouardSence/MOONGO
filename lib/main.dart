import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moongo/app/app.bottomsheets.dart';
import 'package:moongo/app/app.dialogs.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:moongo/services/theme_service.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('fr_FR', null);
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  // Charger le thème
  final themeService = locator<ThemeService>();
  await themeService.loadTheme();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MainApp(themeService: themeService)));
}

class MainApp extends StatelessWidget {
  final ThemeService themeService;

  const MainApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeService.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [StackedService.routeObserver],
        );
      },
    );
  }
}
