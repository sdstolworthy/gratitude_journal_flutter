import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/LoginFormField.dart';
import 'package:flutter_base_app/src/widgets/NoGlowConfiguration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginScreenArguments {
  final bool isLogin;
  LoginScreenArguments(this.isLogin);
}

class LoginScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final bool isLogin;
  LoginScreen(this.isLogin);
  build(context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocListener(
        bloc: authBloc,
        condition: (previousState, currentState) {
          if ((previousState is Unauthenticated ||
                  previousState is Uninitialized) &&
              currentState is Authenticated) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          rootNavigationService.navigateTo(FlutterAppRoutes.itemFeed);
        },
        child: Scaffold(
          body: Container(
            color: Theme.of(context).primaryColor,
            child: ScrollConfiguration(
              behavior: NoGlowScroll(),
              child: ListView(
                children: [
                  AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    leading: FlatButton(
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        onboardingNavigator.goBack();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            isLogin
                                ? localizations.logIn
                                : localizations.signUp,
                            style:
                                TextStyle(fontSize: 40, color: Colors.white60)),
                        SizedBox(
                          height: 80,
                        ),
                        ..._renderLoginForm(context, this.isLogin),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: ButtonTheme(
                              height: 50,
                              child: RaisedButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                    isLogin
                                        ? localizations.logIn
                                        : localizations.signUp,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25)),
                                color: Color.fromRGBO(0, 0, 0, 0.9),
                                highlightColor: Color.fromRGBO(55, 55, 55, 1),
                                onPressed: _handleSignIn(context),
                              ),
                            )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _renderLoginForm(BuildContext context, bool isLogin) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return [
      LoginFormField(
        icon: Icons.person,
        label: toBeginningOfSentenceCase(localizations.username),
        controller: usernameController,
      ),
      LoginFormField(
        icon: Icons.lock,
        label: toBeginningOfSentenceCase(localizations.password),
        isObscured: true,
        controller: passwordController,
      ),
      if (!isLogin)
        LoginFormField(
          controller: confirmPasswordController,
          icon: Icons.lock,
          label: toBeginningOfSentenceCase(localizations.confirmPassword),
          isObscured: true,
        )
    ];
  }

  _handleSignIn(context) {
    return () {
      final username = usernameController.text;
      final password = passwordController.text;
      BlocProvider.of<AuthenticationBloc>(context)
          .dispatch(LogIn(username, password));
    };
  }
}