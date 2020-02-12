import 'package:flutter/material.dart';
import 'package:grateful/src/grateful.dart';
import 'package:grateful/src/config/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final AppEnvironment configuredApp = AppEnvironment(
    child: FlutterApp(),
    cloudStorageBucket: 'gs://dev-gratitude-journal.appspot.com/',
  );
  runApp(configuredApp);
}
