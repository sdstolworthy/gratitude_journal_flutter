import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/authentication/authentication_bloc.dart';
import 'package:grateful/src/blocs/authentication/authentication_state.dart';
import 'package:grateful/src/services/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';

class AuthenticationListener extends StatelessWidget {
  const AuthenticationListener({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: authenticationBloc,
      condition: (AuthenticationState previousState,
          AuthenticationState currentState) {
        if (previousState is! Authenticated && currentState is Authenticated) {
          return true;
        }
        if (previousState is! Unauthenticated &&
            currentState is Unauthenticated) {
          return true;
        }
        if (previousState is! RequiresBiometricsForAuthentication &&
            currentState is RequiresBiometricsForAuthentication) {
          return true;
        }
        return false;
      },
      listener: (BuildContext context, AuthenticationState state) {
        final List<Future<dynamic>> preAuthenticationHookFutures =
            getPreAuthenticationHooks(context)
                .map((LoadingTask hook) => hook.execute())
                .toList();
        try {
          if (state is Unauthenticated ||
              state is RequiresBiometricsForAuthentication) {
            rootNavigationService.returnToLogin();
          } else if (state is Authenticated) {
            Future.wait<void>(<Future<dynamic>>[
              ...getPostAuthenticationHooks(context)
                  .map<Future<dynamic>>((LoadingTask hook) => hook.execute()),
              ...preAuthenticationHookFutures
            ]).then((_) {
              rootNavigationService
                  .pushReplacementNamed(FlutterAppRoutes.journalPageView);
            });
          } else {
            Future.wait<void>(preAuthenticationHookFutures).then((_) {
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
