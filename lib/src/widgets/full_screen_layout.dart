import 'package:flutter/material.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';

class FullScreenLayout extends StatelessWidget {
  const FullScreenLayout({@required this.child, this.headerSliverBuilder});

  final List<Widget> Function(BuildContext, bool) headerSliverBuilder;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: headerSliverBuilder ??
            (BuildContext context, bool isScrolled) => <Widget>[],
        body: BackgroundGradientProvider(
            child: SafeArea(bottom: false, child: child)));
  }
}
