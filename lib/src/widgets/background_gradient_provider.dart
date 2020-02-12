import 'package:flutter/material.dart';

class BackgroundGradientProvider extends StatelessWidget {
  const BackgroundGradientProvider({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.blue[900], Colors.blue[600]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: SizedBox.expand(child: child),
    );
  }
}
