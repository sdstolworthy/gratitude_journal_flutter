import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/services/biometrics.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/language_picker.dart';
import 'package:grateful/src/widgets/logo_hero.dart';
import 'package:grateful/src/widgets/onboarding_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: authenticationBloc,
        builder:
            (BuildContext context, AuthenticationState authenticationState) {
          if (authenticationState is RequiresBiometricsForAuthentication) {
            _showBiometricsDialog(context);
          }
          return Scaffold(body:
              LayoutBuilder(builder: (_, BoxConstraints viewportConstraints) {
            return BackgroundGradientProvider(
              child: SingleChildScrollView(
                  child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        LogoHero(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: OnboardingButton(
                                    buttonText: localizations.logIn,
                                    onPressed: () {
                                      rootNavigationService.navigateTo(
                                          FlutterAppRoutes.loginScreen);
                                    },
                                  )),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: OnboardingButton(
                                    buttonText: localizations.signUp,
                                    isInverted: true,
                                    onPressed: () {
                                      rootNavigationService.navigateTo(
                                          FlutterAppRoutes.signupScreen);
                                    },
                                  )),
                                ],
                              ),
                              if (authenticationState
                                      is RequiresBiometricsForAuthentication ||
                                  authenticationState is Authenticated)
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 75,
                                      width: 75,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.fingerprint,
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                        color: Colors.white,
                                        onPressed: () {
                                          _showBiometricsDialog(context);
                                        },
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                )
                            ],
                          ),
                        ),
                        const LanguagePicker()
                      ],
                    ),
                  ),
                ),
              )),
            );
          }));
        });
  }

  Future<void> _showBiometricsDialog(BuildContext context) async {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    showBiometricsDialog(
        context: context,
        dialogPrompt: AppLocalizations.of(context).unlockJournal,
        onComplete: (bool isAuthenticated) {
          if (isAuthenticated) {
            authenticationBloc.add(Authenticate());
          }
        });
  }
}
