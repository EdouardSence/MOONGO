import 'package:moongo/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:moongo/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:moongo/ui/views/home/home_view.dart';
import 'package:moongo/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:moongo/ui/views/login/login_view.dart';
import 'package:moongo/ui/views/collection/collection_view.dart';
import 'package:moongo/ui/views/tasks/tasks_view.dart';
import 'package:moongo/ui/views/shop/shop_view.dart';
import 'package:moongo/ui/views/profile/profile_view.dart';
import 'package:moongo/ui/views/tabs/tabs_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: CollectionView),
    MaterialRoute(page: TasksView),
    MaterialRoute(page: ShopView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: TabsView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: FirestoreService),
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
