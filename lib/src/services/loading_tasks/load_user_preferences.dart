import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';
import 'package:grateful/src/blocs/localization/localization_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';

class LoadUserPreferences extends LoadingTask {
  final LocalizationBloc localizationBloc;

  final UserPreferenceBloc userPreferenceBloc;

  LoadUserPreferences({this.localizationBloc, this.userPreferenceBloc})
      : super('Loading User Preferences');

  @override
  Future<void> execute() async {
    userPreferenceBloc.add(FetchUserPreferences());

    UserPreferencesFetched userPreferenceState = await userPreferenceBloc
        .firstWhere((state) => state is UserPreferencesFetched);

    localizationBloc.add(ChangeLocalization(Locale(userPreferenceState
            .userPreferenceSettings.userLanguageSettings?.locale ??
        'en')));
  }
}
