import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grateful/src/config/environment.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/widgets/grateful_bloc_provider.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({@required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return AppEnvironment(
      cloudStorageBucket: '',
      isDevelopment: true,
      child: MaterialApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate
        ],
        home: AppBlocProviders(child: child),
      ),
    );
  }
}
