import 'package:moongo/app/app.locator.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:stacked/stacked.dart';

class InfoAlertDialogModel extends BaseViewModel {
  final AuthenticationService authService = locator<AuthenticationService>();

  void logout() {
    authService.signOut();
  }
}
