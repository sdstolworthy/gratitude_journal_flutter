import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/models/preferences/user_preference.dart';

class NotificationSettingsWidget extends StatelessWidget {
  build(context) {
    final ThemeData theme = Theme.of(context);
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    return BlocBuilder(
        bloc: userPreferenceBloc,
        builder: (context, UserPreferenceState userPreferenceState) {
          final isUserPreferencesFetched =
              userPreferenceState is UserPreferencesFetched;
          if (userPreferenceState is! UserPreferencesFetched) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: theme.iconTheme.color,
                    ),
                    title: Text(
                      'Get a Daily Journaling Reminder',
                      style: theme.primaryTextTheme.body1,
                    ),
                    trailing: Switch(
                      onChanged: (newValue) {
                        userPreferenceBloc.add(UpdateUserPreference(
                            new UserPreferenceSettings(
                                dailyJournalReminderSettings:
                                    (userPreferenceState
                                            as UserPreferencesFetched)
                                        .userPreferenceSettings
                                        .dailyJournalReminderSettings
                                        .copyWith(isEnabled: newValue))));
                      },
                      value: isUserPreferencesFetched
                          ? (userPreferenceState as UserPreferencesFetched)
                              .userPreferenceSettings
                              .dailyJournalReminderSettings
                              .isEnabled
                          : false,
                    )),
                ListTile(
                    title: Text(
                      'Reminder Time',
                      style: theme.primaryTextTheme.body1,
                    ),
                    leading: Icon(
                      Icons.alarm,
                      color: theme.iconTheme.color,
                    ),
                    trailing: RaisedButton(
                      onPressed: () async {
                        final initialTime =
                            userPreferenceState is UserPreferencesFetched
                                ? userPreferenceState
                                    .userPreferenceSettings
                                    .dailyJournalReminderSettings
                                    .notificationTime
                                : DateTime.now();
                        final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(initialTime));
                        if (time == null) {
                          return;
                        }
                        final now = DateTime.now();
                        userPreferenceBloc.add(UpdateUserPreference(
                            UserPreferenceSettings(
                                dailyJournalReminderSettings:
                                    (userPreferenceState
                                            as UserPreferencesFetched)
                                        .userPreferenceSettings
                                        .dailyJournalReminderSettings
                                        .copyWith(
                                            notificationTime: DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                time.hour,
                                                time.minute)))));
                      },
                      child: Text(
                          userPreferenceState is UserPreferencesFetched
                              ? userPreferenceState
                                  .userPreferenceSettings
                                  .dailyJournalReminderSettings
                                  .readableReminderTime
                              : 'Select a Time',
                          style: theme.primaryTextTheme.body1),
                    ))
              ],
            );
          }
        });
  }
}
