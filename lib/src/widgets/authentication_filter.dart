import 'package:flutter/widgets.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';

class AuthenticationFilter extends StatelessWidget {
  const AuthenticationFilter(
      {@required this.authenticatedNavigator,
      // @required this.unauthenticatedNavigator,
      @required this.state});

  final Widget authenticatedNavigator;
  // final Widget unauthenticatedNavigator;
  final AuthenticationState state;

  @override
  Widget build(BuildContext context) {
    // if (state is Unauthenticated || state is Uninitialized) {
    return authenticatedNavigator;
    //   return WelcomeScreen();
    // } else {
    //   return authenticatedNavigator;
    // }
  }
}
