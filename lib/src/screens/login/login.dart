import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/login_screen/bloc.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/login_form_field.dart';
import 'package:grateful/src/widgets/logo_hero.dart';
import 'package:grateful/src/widgets/onboarding_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginScreenArguments {
  LoginScreenArguments(this.isLogin);

  final bool isLogin;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen(this.isLogin);

  final bool isLogin;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final LoginScreenBloc _loginScreenBloc =
        LoginScreenBloc(authenticationBloc: authBloc);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            elevation: 0,
            leading: FlatButton(
              child: Icon(
                Icons.arrow_back,
                color: theme.appBarTheme.iconTheme.color,
              ),
              onPressed: () => rootNavigationService.goBack(),
            )),
        body: BlocBuilder<LoginScreenBloc, LoginScreenState>(
            bloc: _loginScreenBloc,
            builder: (BuildContext context, LoginScreenState loginState) {
              if (loginState is LoginFailure) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'Something went wrong while' +
                              (widget.isLogin ? ' logging in' : 'signing up'),
                          style: theme.primaryTextTheme.body1)));
                });
              }
              return BackgroundGradientProvider(
                child: Container(
                  child: SafeArea(
                    child: LayoutBuilder(builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: IntrinsicHeight(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                          constraints: const BoxConstraints(
                                              maxHeight: 100, maxWidth: 100),
                                          child: LogoHero()),
                                      Flexible(
                                        child: Text(
                                          widget.isLogin
                                              ? localizations.loginCTA
                                              : localizations.signupCTA,
                                          style:
                                              theme.primaryTextTheme.display1,
                                        ),
                                      )
                                    ]),
                                    Expanded(child: Container()),
                                    Form(
                                        key: _formKey,
                                        child: _renderLoginForm(
                                            context,
                                            widget.isLogin,
                                            _loginScreenBloc)),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: OnboardingButton(
                                          buttonText: widget.isLogin
                                              ? localizations.logIn
                                              : localizations.signUp,
                                          onPressed: loginState
                                                  is LoginLoading
                                              ? null
                                              : widget.isLogin
                                                  ? () => _handleSignIn(
                                                      _loginScreenBloc)
                                                  : () => _handleRegistration(
                                                      _loginScreenBloc),
                                        )),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              child: GoogleSignInButton(
                                                darkMode: true,
                                                onPressed: () {
                                                  _loginScreenBloc
                                                      .add(AuthWithGoogle());
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }));
  }

  void _handleRegistration(LoginScreenBloc _loginBloc) {
    final String username = emailController.text;
    final String password = passwordController.text;
    if (_formKey.currentState.validate()) {
      _loginBloc.add(SignUp(username, password));
    }
  }

  Widget _renderLoginForm(
      BuildContext context, bool isLogin, LoginScreenBloc loginScreenBloc) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
        bloc: loginScreenBloc,
        builder: (BuildContext context, LoginScreenState loginScreenState) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
            LoginFormField(
              validator: (String input) {
                final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(input);
                if (!emailValid) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              enabled: loginScreenState is! LoginLoading,
              icon: Icons.person,
              label: toBeginningOfSentenceCase(localizations.email),
              controller: emailController,
            ),
            LoginFormField(
              icon: Icons.lock,
              label: toBeginningOfSentenceCase(localizations.password),
              isObscured: true,
              controller: passwordController,
              enabled: loginScreenState is! LoginLoading,
              validator: (String input) {
                if (passwordController.text == null ||
                    passwordController.text == '') {
                  return 'Password must not be blank';
                }
                if (!isLogin &&
                    confirmPasswordController.text != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            if (!isLogin)
              LoginFormField(
                controller: confirmPasswordController,
                icon: Icons.lock,
                enabled: loginScreenState is! LoginLoading,
                label: toBeginningOfSentenceCase(localizations.confirmPassword),
                isObscured: true,
                validator: (String input) {
                  if (confirmPasswordController.text !=
                      passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              )
          ]);
        });
  }

  void _handleSignIn(LoginScreenBloc _loginBloc) {
    final String username = emailController.text;
    final String password = passwordController.text;
    if (_formKey.currentState.validate()) {
      _loginBloc.add(LogIn(username, password));
    }
  }
}
