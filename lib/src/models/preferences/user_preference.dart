import 'dart:convert';

import 'package:grateful/src/models/preferences/daily_notification.dart';
import 'package:grateful/src/models/preferences/language_settings.dart';

class UserPreferenceSettings {
  DailyJournalReminderSettings dailyJournalReminderSettings;
  UserLanguageSettings userLanguageSettings;
  UserPreferenceSettings({
    this.dailyJournalReminderSettings,
    this.userLanguageSettings,
  });

  UserPreferenceSettings copyWith({
    DailyJournalReminderSettings dailyJournalReminderSettings,
    UserLanguageSettings userLanguageSettings,
  }) {
    return UserPreferenceSettings(
      dailyJournalReminderSettings:
          dailyJournalReminderSettings ?? this.dailyJournalReminderSettings,
      userLanguageSettings: userLanguageSettings ?? this.userLanguageSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyJournalReminderSettings': dailyJournalReminderSettings?.toMap(),
      'userLanguageSettings': userLanguageSettings?.toMap(),
    };
  }

  static UserPreferenceSettings fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserPreferenceSettings(
      dailyJournalReminderSettings: map['dailyJournalReminderSettings'] != null
          ? DailyJournalReminderSettings.fromMap(
              Map<String, dynamic>.from(map['dailyJournalReminderSettings']))
          : null,
      userLanguageSettings: map['userLanguageSettings'] != null
          ? UserLanguageSettings.fromMap(
              Map<String, dynamic>.from(map['userLanguageSettings']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  static UserPreferenceSettings fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'UserPreferenceSettings dailyJournalReminderSettings: $dailyJournalReminderSettings, userLanguageSettings: $userLanguageSettings';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserPreferenceSettings &&
        o.dailyJournalReminderSettings == dailyJournalReminderSettings &&
        o.userLanguageSettings == userLanguageSettings;
  }

  @override
  int get hashCode =>
      dailyJournalReminderSettings.hashCode ^ userLanguageSettings.hashCode;
}

abstract class UserPreference {
  Map<String, dynamic> toMap();
}
