import 'package:my_first_app/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:my_first_app/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:my_first_app/ui/views/home/home_view.dart';
import 'package:my_first_app/ui/views/startup/startup_view.dart';
import 'package:my_first_app/ui/views/login/login_view.dart';
import 'package:my_first_app/ui/views/routines/routines_view.dart';
import 'package:my_first_app/ui/views/creatures/creatures_view.dart';
import 'package:my_first_app/ui/views/profile/profile_view.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/firestore_service.dart';
import 'package:my_first_app/services/gamification_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: RoutinesView),
    MaterialRoute(page: CreaturesView),
    MaterialRoute(page: ProfileView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(
      classType: GamificationService,
      resolveUsing: GamificationService.fromLocator,
    ),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
