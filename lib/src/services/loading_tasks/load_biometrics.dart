import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/blocs/biometric/biometric_bloc.dart';

class LoadBiometrics extends LoadingTask {
  LoadBiometrics(this.context) : super('Loading Biometric Status');
  BuildContext context;

  @override
  Future<void> execute() {
    BlocProvider.of<BiometricBloc>(context).add(FetchBiometricsStatus());
    return Future<void>.delayed(Duration.zero);
  }
}
