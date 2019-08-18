import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_base_app/src/repositories/user/userRepository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => Uninitialized();

  final UserRepository _userRepository;

  AuthenticationBloc(UserRepository userRepository)
      : this._userRepository = userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield Unauthenticated();
    } else if (event is LogIn) {
      yield* _mapLoginEventToState(event.username, event.password);
    } else if (event is LogOut) {
      yield* _mapLogoutEventToState();
    }
  }

  Stream<AuthenticationState> _mapLoginEventToState(
      String username, String password) async* {
    try {
      await _userRepository.signInWithCredentials(username, password);
      yield Authenticated();
    } catch (e, s) {
      print(s);
      print(e);
      print("Error during Authentication");
    }
  }

  Stream<AuthenticationState> _mapLogoutEventToState() async* {
    _userRepository.signOut();
  }
}
