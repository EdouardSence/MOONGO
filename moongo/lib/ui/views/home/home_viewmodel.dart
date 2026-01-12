import 'package:moongo/app/app.bottomsheets.dart';
import 'package:moongo/app/app.dialogs.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final AuthenticationService authService = locator<AuthenticationService>();

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      description: 'Vous devrez vous reconnecter pour accéder à votre compte.',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  void logout() {
    authService.signOut();
  }
}
