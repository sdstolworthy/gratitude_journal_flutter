part of 'biometric_bloc.dart';

@immutable
abstract class BiometricState {
  const BiometricState(this.isChecked);

  final bool isChecked;
}

class BiometricInitial extends BiometricState {
  const BiometricInitial(bool isChecked) : super(isChecked);
}

class BiometricStatusFetched extends BiometricState {
  const BiometricStatusFetched(
      {@required this.isCapable,
      @required this.isEnabled,
      @required bool isChecked})
      : super(isChecked);

  final bool isCapable;
  final bool isEnabled;
}

class BiometricStatusLoading extends BiometricState {
  const BiometricStatusLoading(bool isChecked) : super(isChecked);
}
