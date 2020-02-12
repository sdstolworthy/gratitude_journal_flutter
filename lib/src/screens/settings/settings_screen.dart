import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/screens/settings/settings_widgets/app_related_actions.dart';
import 'package:grateful/src/screens/settings/settings_widgets/language_settings_widget.dart';
import 'package:grateful/src/screens/settings/settings_widgets/notification_settings_widget.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    if (userPreferenceBloc is! UserPreferencesFetched) {
      userPreferenceBloc.add(FetchUserPreferences());
    }
    return BackgroundGradientProvider(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          NotificationSettingsWidget(),
          LanguageSettingsWidget(),
          AppRelatedActions(),
        ],
      ),
    );
  }
}
