import 'package:flutter/widgets.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/biometric/biometric_bloc.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/repositories/biometrics/biometrics_repository.dart';
import 'package:grateful/src/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/repositories/user_preferences/user_preference_repository.dart';
import 'package:grateful/src/widgets/authentication_listener.dart';

/// Combines application level bloc stores above the rest of the application
class AppBlocProviders extends StatelessWidget {
  const AppBlocProviders({this.child});
  final Widget child;

  @override
  Widget build(BuildContext _) {
    final BiometricBloc biometricBloc = BiometricBloc(BiometricRepository());
    final AuthenticationBloc authBloc =
        AuthenticationBloc(UserRepository(), biometricBloc);
    final UserPreferenceBloc userPreferenceBloc =
        UserPreferenceBloc(preferenceRepository: UserPreferenceRepository());
    return BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => authBloc,
        child: Builder(builder: (BuildContext subAuthenticationContext) {
          return MultiBlocProvider(providers: <BlocProvider<dynamic>>[
            BlocProvider<LocalizationBloc>(
              create: (_) =>
                  LocalizationBloc(userPreferenceBloc: userPreferenceBloc),
            ),
            BlocProvider<UserPreferenceBloc>(
              create: (_) => userPreferenceBloc,
            ),
            BlocProvider<BiometricBloc>(create: (_) => biometricBloc)
          ], child: AuthenticationListener(child: child));
        }));
  }
}
