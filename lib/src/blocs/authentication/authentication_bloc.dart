import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/blocs/biometric/biometric_bloc.dart';
import 'package:grateful/src/repositories/user/user_repository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(UserRepository userRepository, this.biometricBloc)
      : _userRepository = userRepository;

  final BiometricBloc biometricBloc;

  final UserRepository _userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (biometricBloc.state is! BiometricStatusFetched) {
      biometricBloc.add(FetchBiometricsStatus());
      final Completer<void> c = Completer<void>();
      biometricBloc.listen((BiometricState data) {
        if (data is BiometricStatusFetched) {
          c.complete();
        }
      });
      await c.future;
    }
    if (event is AppStarted) {
      if (await _userRepository.isSignedIn()) {
        if (biometricBloc.state is BiometricStatusFetched &&
            (biometricBloc.state as BiometricStatusFetched).isEnabled &&
            !biometricBloc.state.isChecked) {
          yield RequiresBiometricsForAuthentication();
        } else {
          yield Authenticated();
        }
      } else {
        yield Unauthenticated();
      }
    } else if (event is Authenticate) {
      yield Authenticated();
    } else if (event is Unauthenticate) {
      yield* _mapLogoutEventToState();
    }
  }

  @override
  AuthenticationState get initialState => Uninitialized();

  Stream<AuthenticationState> _mapLogoutEventToState() async* {
    _userRepository.signOut();
    yield Unauthenticated();
  }
}
