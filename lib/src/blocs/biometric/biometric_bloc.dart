import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/biometrics/biometrics_repository.dart';
import 'package:meta/meta.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  BiometricBloc(BiometricRepository biometricRepository)
      : biometricRepository = biometricRepository ?? BiometricRepository();

  final BiometricRepository biometricRepository;

  @override
  BiometricState get initialState => const BiometricInitial(false);

  @override
  Stream<BiometricState> mapEventToState(
    BiometricEvent event,
  ) async* {
    if (event is FetchBiometricsStatus) {
      yield BiometricStatusLoading(state.isChecked);
      final BiometricsStatus biometricsStatus = await getBiometricsStatus();
      yield BiometricStatusFetched(
          isChecked: state.isChecked,
          isCapable: biometricsStatus.isCapable,
          isEnabled: biometricsStatus.isEnabled);
    } else if (event is ToggleBiometrics) {
      yield BiometricStatusLoading(state.isChecked);
      await biometricRepository.toggleBiometrics(event.isEnabled);
      final BiometricsStatus biometricsStatus = await getBiometricsStatus();
      yield BiometricStatusFetched(
          isChecked: state.isChecked,
          isCapable: biometricsStatus.isCapable,
          isEnabled: biometricsStatus.isEnabled);
    }
  }

  Future<BiometricsStatus> getBiometricsStatus() async {
    final List<bool> data = await Future.wait(<Future<bool>>[
      biometricRepository.checkIfDeviceIsCapable(),
      biometricRepository.checkIfBiometricsEnabled()
    ]);
    return BiometricsStatus(data[0], data[1]);
  }
}

class BiometricsStatus {
  BiometricsStatus(this.isCapable, this.isEnabled);

  final bool isCapable;
  final bool isEnabled;
}
