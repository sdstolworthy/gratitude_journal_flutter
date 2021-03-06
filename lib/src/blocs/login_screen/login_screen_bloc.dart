import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/repositories/user/user_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc(
      {UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc,
      FirebaseAnalytics analytics})
      : _authenticationBloc = authenticationBloc,
        _userRepository = userRepository ?? UserRepository(),
        _analytics = analytics ?? FirebaseAnalytics();

  final FirebaseAnalytics _analytics;
  final AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepository;

  @override
  LoginScreenState get initialState => InitialLoginScreenState();

  @override
  Stream<LoginScreenState> mapEventToState(
    LoginScreenEvent event,
  ) async* {
    yield LoginLoading();

    if (event is RequiresUserToBeSignedOut) {
      try {
        _userRepository.signOut();
      } catch (e) {
        print('Sign out error. Maybe the user is already signed out?');
      }
    }

    if (event is LogIn) {
      yield* _mapLoginEventToState(event.username, event.password);
    } else if (event is SignUp) {
      yield* _mapSignUpEventToState(event.username, event.password);
    } else if (event is AuthWithGoogle) {
      try {
        await _userRepository.signInWithGoogle();
        _authenticationBloc.add(Authenticate());
        yield InitialLoginScreenState();
      } catch (e, s) {
        print(s);
        print(e);
        print('Error with google auth');
        yield LoginFailure();
      }
    }
  }

  Stream<LoginScreenState> _mapSignUpEventToState(
      String username, String password) async* {
    try {
      yield LoginLoading();
      await _userRepository.signUp(email: username, password: password);
      _authenticationBloc.add(Authenticate());
      _analytics.logSignUp(signUpMethod: 'email');
      yield InitialLoginScreenState();
    } catch (e) {
      print(e);
      yield LoginFailure();
    }
  }

  Stream<LoginScreenState> _mapLoginEventToState(
      String username, String password) async* {
    try {
      yield LoginLoading();
      await _userRepository.signInWithCredentials(username, password);
      _authenticationBloc.add(Authenticate());
      _analytics.logLogin(loginMethod: 'email').catchError((Object e) {
        print('error logging event to GA');
      });
      yield InitialLoginScreenState();
    } catch (e, s) {
      print(e);
      print(s);
      print('Error during Authentication');
      _authenticationBloc.add(Unauthenticate());
      yield LoginFailure();
    }
  }
}
