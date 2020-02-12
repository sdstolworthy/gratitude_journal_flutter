import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:local_auth/local_auth.dart';

Future<void> showBiometricsDialog(
    {@required BuildContext context,
    @required void Function(bool authenticationStatus) onComplete}) async {
  final LocalAuthentication localAuthentication = LocalAuthentication();

  final AppLocalizations localizations = AppLocalizations.of(context);
  try {
    localAuthentication.stopAuthentication();
  } catch (e) {
    print('Could not stop authentication');
  }
  try {
    final bool didAuthenticate =
        await localAuthentication.authenticateWithBiometrics(
            localizedReason: localizations.verifyBiometrics);
    onComplete(didAuthenticate);
  } on PlatformException catch (e) {
    print(e);
    if (e.code == 'auth_in_progress') {
      print('mep');
    }
    localAuthentication.stopAuthentication();
    onComplete(false);
    return;
  }
}
