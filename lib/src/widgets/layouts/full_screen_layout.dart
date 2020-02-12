import 'package:flutter/material.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/no_glow_configuration.dart';

typedef OnScrollNotification = bool Function(
    ScrollNotification scrollNotification);

class FullScreenLayout extends StatelessWidget {
  const FullScreenLayout(
      {this.backgroundColor,
      this.child,
      this.sliverAppBar,
      this.onScrollNotification,
      this.floatingActionButton,
      this.scaffoldKey});

  final Color backgroundColor;
  final Widget child;
  final SliverAppBar sliverAppBar;
  final OnScrollNotification onScrollNotification;
  final Widget floatingActionButton;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification ??
          (ScrollNotification scrollNotification) => false,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: sliverAppBar,
            )
          ];
        },
        body: Scaffold(
          key: scaffoldKey,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BackgroundGradientProvider(
              child: SafeArea(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints layoutConstraints) {
                  return ScrollConfiguration(
                    behavior: NoGlowScroll(showLeading: true),
                    child: child,
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
