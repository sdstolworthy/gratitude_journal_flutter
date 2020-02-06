import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/localization/localization_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/services/loading_tasks/load_cloud_messenger.dart';
import 'package:grateful/src/services/loading_tasks/load_journal_feed.dart';
import 'package:grateful/src/services/loading_tasks/load_notifications.dart';
import 'package:grateful/src/services/loading_tasks/load_user_preferences.dart';

abstract class LoadingTask {
  Future<void> execute();

  final String loadingText;
  LoadingTask(this.loadingText);
}

List<LoadingTask> getPreAuthenticationHooks() {
  return [InitializeCloudMessaging(), LoadNotifications()];
}

List<LoadingTask> getPostAuthenticationHooks(BuildContext context) {
  final LocalizationBloc localizationBloc =
      BlocProvider.of<LocalizationBloc>(context);
  final UserPreferenceBloc userPreferenceBloc =
      BlocProvider.of<UserPreferenceBloc>(context);
  return [
    LoadJournalFeed(context),
    LoadUserPreferences(
        localizationBloc: localizationBloc,
        userPreferenceBloc: userPreferenceBloc)
  ];
}
