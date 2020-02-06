import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/user_preferences/user_preference_repository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/notifications/notification_service.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  AppLocalizations appLocalizations;

  NotificationService notificationService;

  NotificationBloc(
      {@required AppLocalizations appLocalizations,
      @required NotificationService notificationService,
      UserPreferenceRepository userPreferenceRepository}) {
    assert(notificationService != null);
    assert(appLocalizations != null);

    this.notificationService = notificationService;
    this.appLocalizations = appLocalizations;
  }

  @override
  NotificationState get initialState => NotificationInitial();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is AddDailyJournalReminderNotification) {
      yield* mapDailyNotification(event);
    }
  }

  Stream<NotificationState> mapDailyNotification(
      NotificationEvent event) async* {
    if (event is AddDailyJournalReminderNotification) {
      notificationService.setDailyNotificationAtTime(
          event.time,
          new NotificationInformation(
            body: 'Take some time to write down what you\'re thankful for',
            title: 'What are you grateful for today?',
          ),
          channelInformation: dailyJournalingReminder);
    }
  }
}
