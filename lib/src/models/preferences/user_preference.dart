import 'dart:convert';

import 'package:grateful/src/models/preferences/color_preference.dart';
import 'package:grateful/src/models/preferences/daily_notification.dart';
import 'package:grateful/src/models/preferences/language_settings.dart';

class UserPreferenceSettings {
  UserPreferenceSettings(
      {this.dailyJournalReminderSettings,
      this.userLanguageSettings,
      this.colorPreference});

  DailyJournalReminderSettings dailyJournalReminderSettings;
  UserLanguageSettings userLanguageSettings;
  ColorPreference colorPreference;

  @override
  int get hashCode =>
      dailyJournalReminderSettings.hashCode ^
      userLanguageSettings.hashCode ^
      colorPreference.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserPreferenceSettings &&
        other.dailyJournalReminderSettings == dailyJournalReminderSettings &&
        other.userLanguageSettings == userLanguageSettings &&
        other.colorPreference == colorPreference;
  }

  @override
  String toString() =>
      'UserPreferenceSettings dailyJournalReminderSettings: $dailyJournalReminderSettings, userLanguageSettings: $userLanguageSettings, colorPreference: $colorPreference';

  UserPreferenceSettings copyWith(
      {DailyJournalReminderSettings dailyJournalReminderSettings,
      UserLanguageSettings userLanguageSettings,
      ColorPreference colorPreference}) {
    return UserPreferenceSettings(
        dailyJournalReminderSettings:
            dailyJournalReminderSettings ?? this.dailyJournalReminderSettings,
        userLanguageSettings: userLanguageSettings ?? this.userLanguageSettings,
        colorPreference: colorPreference ?? this.colorPreference);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailyJournalReminderSettings': dailyJournalReminderSettings?.toMap(),
      'userLanguageSettings': userLanguageSettings?.toMap(),
      'colorPreference': colorPreference?.toMap(),
    };
  }

  static UserPreferenceSettings fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return UserPreferenceSettings(
        dailyJournalReminderSettings: map['dailyJournalReminderSettings'] !=
                null
            ? DailyJournalReminderSettings.fromMap(Map<String, dynamic>.from(
                map['dailyJournalReminderSettings'] as Map<String, dynamic>))
            : null,
        userLanguageSettings: map['userLanguageSettings'] != null
            ? UserLanguageSettings.fromMap(Map<String, dynamic>.from(
                map['userLanguageSettings'] as Map<String, dynamic>))
            : null,
        colorPreference: map['colorPreference'] != null
            ? ColorPreference.fromMap(
                Map<String, dynamic>.from(
                    map['colorPreference'] as Map<String, dynamic>),
              )
            : null);
  }

  String toJson() => json.encode(toMap());

  static UserPreferenceSettings fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

abstract class UserPreference {
  Map<String, dynamic> toMap();
}
