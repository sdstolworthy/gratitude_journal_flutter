import 'dart:convert';

import 'package:grateful/src/models/preferences/user_preference.dart';
import 'package:intl/intl.dart';

class DailyJournalReminderSettings extends UserPreference {
  DailyJournalReminderSettings({
    this.isEnabled,
    DateTime notificationTime,
  }) {
    this.notificationTime = notificationTime ?? DateTime.now();
  }

  final bool isEnabled;
  DateTime notificationTime;

  @override
  int get hashCode => isEnabled.hashCode ^ notificationTime.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DailyJournalReminderSettings &&
        other.isEnabled == isEnabled &&
        other.notificationTime == notificationTime;
  }

  @override
  String toString() =>
      'UserDailyNotificationSettings isEnabled: $isEnabled, notificationTime: $notificationTime';

  String get readableReminderTime {
    return DateFormat.jm().format(notificationTime).toString();
  }

  DailyJournalReminderSettings copyWith({
    bool isEnabled,
    DateTime notificationTime,
  }) {
    return DailyJournalReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isEnabled': isEnabled,
      'notificationTime': notificationTime?.toIso8601String(),
    };
  }

  static DailyJournalReminderSettings fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return DailyJournalReminderSettings(
      isEnabled: map['isEnabled'] as bool,
      notificationTime: DateTime.tryParse(map['notificationTime'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  static DailyJournalReminderSettings fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
