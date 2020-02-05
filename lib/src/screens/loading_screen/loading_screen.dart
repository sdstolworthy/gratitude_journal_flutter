import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/screens/loading_screen/loading_tasks/load_cloud_messenger.dart';
import 'package:grateful/src/screens/loading_screen/loading_tasks/load_journal_feed.dart';
import 'package:grateful/src/screens/loading_screen/loading_tasks/load_notifications.dart';
import 'package:grateful/src/screens/loading_screen/loading_tasks/loading_task.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/logo_hero.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<LoadingTask> preAuthenticationHooks = [];

  List<LoadingTask> postAuthenticationHooks = [];

  build(context) {
    preAuthenticationHooks = [InitializeCloudMessaging(), LoadNotifications()];
    postAuthenticationHooks = [LoadJournalFeed(context)];
    BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    final List<Future<dynamic>> preAuthenticationHookFutures =
        preAuthenticationHooks.map((hook) => hook.execute()).toList();
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      condition: (prev, curr) {
        return true;
      },
      listener: (context, AuthenticationState state) {
        try {
          if (state is Authenticated) {
            Future.wait(<Future<dynamic>>[
              ...postAuthenticationHooks
                  .map<Future<dynamic>>((hook) => hook.execute()),
              ...preAuthenticationHookFutures
            ]).then((_) {
              rootNavigationService
                  .pushReplacementNamed(FlutterAppRoutes.journalPageView);
            });
          } else if (state is Unauthenticated) {
            Future.wait(preAuthenticationHookFutures).then((_) {
              rootNavigationService.returnToLogin();
            });
          }
        } catch (e) {
          print(e);
          rootNavigationService.returnToLogin();
        }
      },
      child: Container(
        color: Colors.blue[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[LogoHero(), CircularProgressIndicator()],
        ),
      ),
    );
  }
}
