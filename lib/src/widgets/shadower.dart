import 'package:flutter/material.dart';

class Shadower extends StatelessWidget {
  const Shadower({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: const BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(spreadRadius: 0.5, blurRadius: 1, offset: Offset(0.5, 0.5))
      ]),
    );
  }
}
