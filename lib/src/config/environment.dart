import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppEnvironment extends InheritedWidget {
  const AppEnvironment(
      {@required this.cloudStorageBucket,
      @required Widget child,
      @required this.isDevelopment})
      : super(child: child);

  final String cloudStorageBucket;
  final bool isDevelopment;

  static AppEnvironment of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppEnvironment>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
