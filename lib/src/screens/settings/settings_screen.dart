import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/screens/settings/settings_widgets/app_related_actions.dart';
import 'package:grateful/src/screens/settings/settings_widgets/color_settings.dart';
import 'package:grateful/src/screens/settings/settings_widgets/language_settings_widget.dart';
import 'package:grateful/src/screens/settings/settings_widgets/notification_settings_widget.dart';
import 'package:grateful/src/screens/settings/settings_widgets/security_settings.dart';
import 'package:grateful/src/widgets/full_screen_layout.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    if (userPreferenceBloc is! UserPreferencesFetched) {
      userPreferenceBloc.add(FetchUserPreferences());
    }
    return FullScreenLayout(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          NotificationSettingsWidget(),
          LanguageSettingsWidget(),
          SecuritySettings(),
          ColorSettingsWidget(),
          AppRelatedActions(),
        ],
      ),
    );
  }
}
