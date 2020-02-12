part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class AddDailyJournalReminderNotification extends NotificationEvent {
  AddDailyJournalReminderNotification(this.time);

  final DateTime time;
}

class CancelDailyJournalReminderNotification extends NotificationEvent {}
