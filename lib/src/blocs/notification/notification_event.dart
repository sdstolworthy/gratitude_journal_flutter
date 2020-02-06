part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class AddDailyJournalReminderNotification extends NotificationEvent {
  final DateTime time;
  AddDailyJournalReminderNotification(this.time);
}

class CancelDailyJournalReminderNotification extends NotificationEvent {}
