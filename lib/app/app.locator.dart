// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/authentication_service.dart';
import '../services/firestore_service.dart';
import '../services/streak_service.dart';
import '../services/theme_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => ThemeService());
  locator.registerLazySingleton(() => StreakService());
}
