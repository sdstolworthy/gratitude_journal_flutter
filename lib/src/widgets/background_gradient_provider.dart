import 'package:flutter/material.dart';

class BackgroundGradientProvider extends StatelessWidget {
  const BackgroundGradientProvider({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        theme.colorScheme.background,
        theme.colorScheme.secondary
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SizedBox.expand(child: child),
    );
  }
}
