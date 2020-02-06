import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';
import 'package:grateful/src/blocs/localization/localization_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/localizations/localizations.dart';

class LoadUserPreferences extends LoadingTask {
  final BuildContext context;

  LoadUserPreferences(this.context) : super('Loading User Preferences');

  @override
  Future<void> execute() async {
    final preferenceProvider = BlocProvider.of<UserPreferenceBloc>(context);
    preferenceProvider.add(FetchUserPreferences());

    final UserPreferencesFetched preferenceState = await preferenceProvider
        .singleWhere((state) => state is UserPreferencesFetched);
    final localeString =
        preferenceState.userPreferenceSettings.userLanguageSettings.locale;

    BlocProvider.of<LocalizationBloc>(context)
        .add(ChangeLocalization(Locale(localeString)));
  }
}
