part of 'biometric_bloc.dart';

@immutable
abstract class BiometricEvent {}

class FetchBiometricsStatus extends BiometricEvent {}

class ToggleBiometrics extends BiometricEvent {
  ToggleBiometrics(this.isEnabled);

  final bool isEnabled;
}
