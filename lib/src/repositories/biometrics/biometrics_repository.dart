import 'package:grateful/src/config/constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricRepository {
  final Future<SharedPreferences> sharedPreferences;
  final LocalAuthentication localAuthentication;

  BiometricRepository(
      {Future<SharedPreferences> sharedPreferences,
      LocalAuthentication localAuthentication})
      : this.sharedPreferences =
            sharedPreferences ?? SharedPreferences.getInstance(),
        this.localAuthentication = localAuthentication ?? LocalAuthentication();

  Future<bool> checkIfDeviceIsCapable() async {
    return localAuthentication.canCheckBiometrics;
  }

  Future<bool> checkIfBiometricsEnabled() async {
    final sharedPreferences = await this.sharedPreferences;
    final deviceIsCapable = await this.checkIfDeviceIsCapable();
    final biometricsEnabled =
        sharedPreferences.getBool(Constants.biometricsEnabledKey);

    return deviceIsCapable && (biometricsEnabled ?? false);
  }

  Future<void> toggleBiometrics(bool biometricsStatus) async {
    final sharedPreferences = await this.sharedPreferences;

    sharedPreferences.setBool(Constants.biometricsEnabledKey, biometricsStatus);

    return null;
  }
}
