import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/notifications/notification_service.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(
      {@required this.appLocalizations, @required this.notificationService})
      : assert(notificationService != null),
        assert(appLocalizations != null);

  AppLocalizations appLocalizations;
  NotificationService notificationService;

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is AddDailyJournalReminderNotification) {
      yield* mapDailyNotification(event);
    }
  }

  @override
  NotificationState get initialState => NotificationInitial();

  Stream<NotificationState> mapDailyNotification(
      NotificationEvent event) async* {
    if (event is AddDailyJournalReminderNotification) {
      notificationService.setDailyNotificationAtTime(
          event.time,
          NotificationInformation(
            body: appLocalizations.dailyJournalReminderBody,
            title: appLocalizations.dailyJournalReminderTitle,
          ),
          channelInformation: dailyJournalingReminder);
    }
  }
}
