import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/screens/settings/notification_settings/notification_settings_widget.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';

class SettingsScreen extends StatelessWidget {
  build(context) {
    final UserPreferenceBloc userPreferenceBloc =
        BlocProvider.of<UserPreferenceBloc>(context);
    if (userPreferenceBloc is! UserPreferencesFetched) {
      userPreferenceBloc.add(FetchUserPreferences());
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: BackgroundGradientProvider(
        child: ListView(
          children: <Widget>[NotificationSettingsWidget()],
        ),
      ),
    );
  }
}
