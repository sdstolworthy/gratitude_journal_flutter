import 'package:flutter/material.dart';

class NoGlowScroll extends ScrollBehavior {
  NoGlowScroll(
      {this.showLeading = true,
      this.showTrailing = true,
      this.axisDirection = AxisDirection.down,
      Color color})
      : color = color ?? Colors.white.withOpacity(0.1);

  final AxisDirection axisDirection;
  final Color color;
  final bool showLeading;
  final bool showTrailing;

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return GlowingOverscrollIndicator(
      color: color,
      axisDirection: axisDirection,
      showTrailing: showTrailing,
      showLeading: showLeading,
      child: child,
    );
  }
}
