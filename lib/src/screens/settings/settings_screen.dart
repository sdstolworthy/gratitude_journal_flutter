import 'package:flutter/material.dart';
import 'package:grateful/src/screens/settings/notification_settings/notification_settings_widget.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';

class SettingsScreen extends StatelessWidget {
  build(context) {
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
