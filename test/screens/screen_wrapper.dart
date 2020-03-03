import 'package:flutter/material.dart';
import 'package:grateful/src/config/environment.dart';
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
        home: AppBlocProviders(child: child),
      ),
    );
  }
}
