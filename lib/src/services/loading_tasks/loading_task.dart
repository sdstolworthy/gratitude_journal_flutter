import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/localization/localization_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/services/loading_tasks/load_biometrics.dart';
import 'package:grateful/src/services/loading_tasks/load_cloud_messenger.dart';
import 'package:grateful/src/services/loading_tasks/load_notifications.dart';
import 'package:grateful/src/services/loading_tasks/load_user_preferences.dart';

abstract class LoadingTask {
  Future<void> execute();

  final String loadingText;
  LoadingTask(this.loadingText);
}

List<LoadingTask> getPreAuthenticationHooks(BuildContext context) {
  return [
    InitializeCloudMessaging(),
    LoadNotifications(),
    LoadBiometrics(context)
  ];
}

List<LoadingTask> getPostAuthenticationHooks(BuildContext context) {
  final LocalizationBloc localizationBloc =
      BlocProvider.of<LocalizationBloc>(context);
  final UserPreferenceBloc userPreferenceBloc =
      BlocProvider.of<UserPreferenceBloc>(context);
  return [
    LoadUserPreferences(
        localizationBloc: localizationBloc,
        userPreferenceBloc: userPreferenceBloc)
  ];
}
