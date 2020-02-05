import 'package:flutter/widgets.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/localization/bloc.dart';
import 'package:grateful/src/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Combines application level bloc stores above the rest of the application
class AppBlocProviders extends StatelessWidget {
  final Widget child;
  AppBlocProviders({this.child});
  final AuthenticationBloc authBloc = AuthenticationBloc(new UserRepository());
  Widget build(BuildContext _) {
    return BlocProvider(
        create: (context) => authBloc,
        child: Builder(builder: (subAuthenticationContext) {
          return MultiBlocProvider(providers: [
            BlocProvider<LocalizationBloc>(
              create: (_) => LocalizationBloc(),
            ),
          ], child: child);
        }));
  }
}
