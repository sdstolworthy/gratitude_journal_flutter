part of 'user_preference_bloc.dart';

@immutable
abstract class UserPreferenceEvent {}

class FetchUserPreferences extends UserPreferenceEvent {}

class UpdateUserPreference extends UserPreferenceEvent {
  final UserPreferenceSettings userPreferenceSettings;
  UpdateUserPreference(this.userPreferenceSettings);
}
