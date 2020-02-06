import 'dart:convert';

import 'package:grateful/src/models/preferences/user_preference.dart';
import 'package:intl/intl.dart';

class DailyJournalReminderSettings extends UserPreference {
  final bool isEnabled;
  DateTime notificationTime;
  DailyJournalReminderSettings({
    this.isEnabled,
    notificationTime,
  }) {
    this.notificationTime = notificationTime ?? DateTime.now();
  }

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

  Map<String, dynamic> toMap() {
    return {
      'isEnabled': isEnabled,
      'notificationTime': notificationTime?.toIso8601String(),
    };
  }

  static DailyJournalReminderSettings fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DailyJournalReminderSettings(
      isEnabled: map['isEnabled'],
      notificationTime: DateTime.tryParse(map['notificationTime']),
    );
  }

  String toJson() => json.encode(toMap());

  static DailyJournalReminderSettings fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'UserDailyNotificationSettings isEnabled: $isEnabled, notificationTime: $notificationTime';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DailyJournalReminderSettings &&
        o.isEnabled == isEnabled &&
        o.notificationTime == notificationTime;
  }

  @override
  int get hashCode => isEnabled.hashCode ^ notificationTime.hashCode;
}
