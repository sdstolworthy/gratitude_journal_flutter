import 'package:flutter/widgets.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';
import 'package:grateful/src/blocs/user_preference/user_preference_bloc.dart';
import 'package:grateful/src/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/repositories/user_preferences/user_preference_repository.dart';
import 'package:grateful/src/widgets/authentication_listener.dart';

/// Combines application level bloc stores above the rest of the application
class AppBlocProviders extends StatelessWidget {
  AppBlocProviders({this.child});

  final AuthenticationBloc authBloc = AuthenticationBloc(UserRepository());
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            )
          ], child: AuthenticationListener(child: child));
        }));
  }
}
