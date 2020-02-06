part of 'user_preference_bloc.dart';

@immutable
abstract class UserPreferenceState {}

class UserPreferenceInitial extends UserPreferenceState {}

class UserPreferencesFetched extends UserPreferenceState {
  final UserPreferenceSettings userPreferenceSettings;
  UserPreferencesFetched(this.userPreferenceSettings);
}

class UserPreferenceError extends UserPreferenceState {}
