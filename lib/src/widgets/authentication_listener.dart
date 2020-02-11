import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/authentication/authentication_bloc.dart';
import 'package:grateful/src/blocs/authentication/authentication_state.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';

class AuthenticationListener extends StatelessWidget {
  final Widget child;

  AuthenticationListener({@required this.child});

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: authenticationBloc,
      condition: (previousState, currentState) {
        if (previousState is! Authenticated && currentState is Authenticated) {
          return true;
        }
        if (previousState is! Unauthenticated &&
            currentState is Unauthenticated) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        final List<Future<dynamic>> preAuthenticationHookFutures =
            getPreAuthenticationHooks(context)
                .map((hook) => hook.execute())
                .toList();
        try {
          if (state is Unauthenticated) {
            rootNavigationService.returnToLogin();
          }
          if (state is Authenticated) {
            Future.wait(<Future<dynamic>>[
              ...getPostAuthenticationHooks(context)
                  .map<Future<dynamic>>((hook) => hook.execute()),
              ...preAuthenticationHookFutures
            ]).then((_) {
              rootNavigationService
                  .pushReplacementNamed(FlutterAppRoutes.journalPageView);
            });
          } else {
            Future.wait(preAuthenticationHookFutures).then((_) {
              rootNavigationService.returnToLogin();
            });
          }
        } catch (e) {
          print(e);
          rootNavigationService.returnToLogin();
        }
      },
      child: child,
    );
  }
}
