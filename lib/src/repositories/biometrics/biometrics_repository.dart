import 'package:grateful/src/config/constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricRepository {
  BiometricRepository(
      {Future<SharedPreferences> sharedPreferences,
      LocalAuthentication localAuthentication})
      : sharedPreferences =
            sharedPreferences ?? SharedPreferences.getInstance(),
        localAuthentication = localAuthentication ?? LocalAuthentication();
  final Future<SharedPreferences> sharedPreferences;
  final LocalAuthentication localAuthentication;

  Future<bool> checkIfDeviceIsCapable() async {
    return localAuthentication.canCheckBiometrics;
  }

  Future<bool> checkIfBiometricsEnabled() async {
    final SharedPreferences sharedPreferences = await this.sharedPreferences;
    final bool deviceIsCapable = await checkIfDeviceIsCapable();
    final bool biometricsEnabled =
        sharedPreferences.getBool(Constants.biometricsEnabledKey);

    return deviceIsCapable && (biometricsEnabled ?? false);
  }

  Future<void> toggleBiometrics(bool biometricsStatus) async {
    final SharedPreferences sharedPreferences = await this.sharedPreferences;

    sharedPreferences.setBool(Constants.biometricsEnabledKey, biometricsStatus);

    return;
  }
}
