import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grateful/src/models/preferences/user_preference.dart';
import 'package:grateful/src/repositories/user_preferences/user_preference_repository.dart';
import 'package:meta/meta.dart';

part 'user_preference_event.dart';
part 'user_preference_state.dart';

class UserPreferenceBloc
    extends Bloc<UserPreferenceEvent, UserPreferenceState> {
  UserPreferenceRepository preferenceRepository;

  UserPreferenceBloc({@required this.preferenceRepository});

  @override
  UserPreferenceState get initialState => UserPreferenceInitial();

  @override
  Stream<UserPreferenceState> mapEventToState(
    UserPreferenceEvent event,
  ) async* {
    if (event is FetchUserPreferences) {
      final settings = await preferenceRepository.getUserSettings();
      yield UserPreferencesFetched(settings);
    } else if (event is UpdateUserPreference) {
      final settings = await preferenceRepository
          .updateUserSettings(event.userPreferenceSettings);
      yield UserPreferencesFetched(settings);
    }
  }
}
