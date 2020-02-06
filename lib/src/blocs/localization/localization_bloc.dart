import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/models/preferences/language_settings.dart';
import 'bloc.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationState get initialState => LocalizationState(Locale('en'));

  UserPreferenceBloc userPreferenceBloc;

  LocalizationBloc({this.userPreferenceBloc});

  @override
  Stream<LocalizationState> mapEventToState(LocalizationEvent event) async* {
    if (event is ChangeLocalization) {
      userPreferenceBloc.add(UpdateUserPreference<UserLanguageSettings>(
          UserLanguageSettings(locale: event.locale.toString())));
      yield LocalizationState(event.locale);
    }
  }
}
