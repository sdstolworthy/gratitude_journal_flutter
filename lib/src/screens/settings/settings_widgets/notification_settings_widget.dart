import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/notification/notification_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/models/preferences/daily_notification.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/notifications/notification_service.dart';

class NotificationSettingsWidget extends StatefulWidget {
  @override
  _NotificationSettingsWidgetState createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    return BlocProvider<NotificationBloc>(
      create: (_) => NotificationBloc(
          appLocalizations: AppLocalizations.of(context),
          notificationService: NotificationService()),
      child: BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
          bloc: userPreferenceBloc,
          builder:
              (BuildContext context, UserPreferenceState userPreferenceState) {
            if (userPreferenceState is! UserPreferencesFetched) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: theme.iconTheme.color,
                      ),
                      title: Text(
                        localizations.getADailyReminder,
                        style: theme.primaryTextTheme.body1,
                      ),
                      trailing: Switch(
                        onChanged: (bool newValue) {
                          toggleNotifications(context, newValue);
                        },
                        activeColor: theme.colorScheme.primary,
                        value: (userPreferenceState as UserPreferencesFetched)
                                ?.userPreferenceSettings
                                ?.dailyJournalReminderSettings
                                ?.isEnabled ??
                            false || false,
                      )),
                  ListTile(
                      title: Text(
                        localizations.reminderTime,
                        style: theme.primaryTextTheme.body1,
                      ),
                      leading: Icon(
                        Icons.alarm,
                        color: theme.iconTheme.color,
                      ),
                      trailing: RaisedButton(
                        onPressed: () async {
                          setNotificationTime(context);
                        },
                        child: Text(
                            userPreferenceState is UserPreferencesFetched
                                ? userPreferenceState
                                        .userPreferenceSettings
                                        ?.dailyJournalReminderSettings
                                        ?.readableReminderTime ??
                                    localizations.chooseATime
                                : localizations.chooseATime,
                            style: theme.primaryTextTheme.body1),
                      ))
                ],
              );
            }
          }),
    );
  }

  Future<void> toggleNotifications(BuildContext context, bool isEnabled) async {
    final NotificationBloc notificationBloc =
        BlocProvider.of<NotificationBloc>(context);

    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    if (userPreferenceBloc.state is UserPreferencesFetched) {
      final DailyJournalReminderSettings existingReminderSettings =
          (userPreferenceBloc.state as UserPreferencesFetched)
              .userPreferenceSettings
              .dailyJournalReminderSettings;

      notificationBloc.add(CancelDailyJournalReminderNotification());
      if (isEnabled) {
        notificationBloc.add(AddDailyJournalReminderNotification(
            existingReminderSettings?.notificationTime ?? DateTime.now()));
      }

      userPreferenceBloc.add(UpdateUserPreference<DailyJournalReminderSettings>(
          existingReminderSettings?.copyWith(isEnabled: isEnabled) ??
              DailyJournalReminderSettings(isEnabled: isEnabled)));
    }
  }

  Future<void> setNotificationTime(BuildContext context) async {
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    final NotificationBloc notificationBloc =
        BlocProvider.of<NotificationBloc>(context);
    final DateTime initialTime = userPreferenceBloc.state is UserPreferencesFetched
        ? (userPreferenceBloc.state as UserPreferencesFetched)
            .userPreferenceSettings
            .dailyJournalReminderSettings
            .notificationTime
        : DateTime.now();
    final TimeOfDay time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(initialTime));
    if (time == null) {
      return;
    }
    final DateTime now = DateTime.now();
    final DateTime notificationTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    final DailyJournalReminderSettings dailyReminderSettings =
        (userPreferenceBloc.state as UserPreferencesFetched)
            .userPreferenceSettings
            .dailyJournalReminderSettings
            .copyWith(notificationTime: notificationTime);

    notificationBloc.add(CancelDailyJournalReminderNotification());

    if (dailyReminderSettings.isEnabled) {
      notificationBloc.add(AddDailyJournalReminderNotification(
          dailyReminderSettings.notificationTime));
    }

    userPreferenceBloc.add(UpdateUserPreference<DailyJournalReminderSettings>(
        dailyReminderSettings));
  }
}
