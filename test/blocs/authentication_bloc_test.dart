import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:matcher/src/type_matcher.dart' as type_matcher;
import 'package:bloc_test/bloc_test.dart';
import 'package:grateful/src/blocs/authentication/authentication_bloc.dart';
import 'package:grateful/src/blocs/authentication/authentication_event.dart';
import 'package:grateful/src/blocs/authentication/authentication_state.dart';
import 'package:grateful/src/blocs/biometric/biometric_bloc.dart';
import 'package:grateful/src/repositories/biometrics/biometrics_repository.dart';
import 'package:grateful/src/repositories/user/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockBiometricsBloc extends Mock implements BiometricBloc {}

class MockBiometricsRepository extends Mock implements BiometricRepository {}

void main() {
  group('AuthenticationBloc', () {
    AuthenticationBloc authenticationBloc;
    BiometricBloc biometricBloc;
    MockUserRepository userRepository;
    BiometricRepository biometricRepository;

    setUp(() {
      userRepository = MockUserRepository();
      biometricRepository = MockBiometricsRepository();
      biometricBloc = BiometricBloc(biometricRepository);
      authenticationBloc = AuthenticationBloc(userRepository, biometricBloc);
    });

    void setBiometricsCapability(bool isEnabled) {
      when(biometricRepository.checkIfDeviceIsCapable())
          .thenAnswer((_) => Future<bool>.value(isEnabled));
      when(biometricRepository.checkIfBiometricsEnabled())
          .thenAnswer((_) => Future<bool>.value(isEnabled));
    }

    test('initial state is Uninitialized', () {
      expect(authenticationBloc.initialState, isA<Uninitialized>());
    });

    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Expect Authenticated if User is logged in and biometrics are not enabled',
        skip: 0,
        build: () async {
          when(userRepository.isSignedIn())
              .thenAnswer((_) => Future<bool>.value(true));
          setBiometricsCapability(false);
          return authenticationBloc;
        },
        expect: <type_matcher.TypeMatcher<dynamic>>[
          isA<Uninitialized>(),
          isA<Authenticated>()
        ],
        act: (AuthenticationBloc authenticationBloc) async =>
            authenticationBloc.add(AppStarted()));

    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Expect RequiresBiometricsForAuthentication if User logged in and biometrics are enabled',
        skip: 0,
        build: () async {
          when(userRepository.isSignedIn())
              .thenAnswer((_) => Future<bool>.value(true));
          setBiometricsCapability(true);
          return authenticationBloc;
        },
        expect: <TypeMatcher<dynamic>>[
          isA<Uninitialized>(),
          isA<RequiresBiometricsForAuthentication>()
        ],
        act: (AuthenticationBloc bloc) async => bloc.add(AppStarted()));

    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Expect Unauthenticated when the user is not logged in',
        skip: 0,
        build: () async {
          when(userRepository.isSignedIn())
              .thenAnswer((_) => Future<bool>.value(false));
          setBiometricsCapability(true);
          return authenticationBloc;
        },
        expect: <TypeMatcher<AuthenticationState>>[
          isA<Uninitialized>(),
          isA<Unauthenticated>()
        ],
        act: (AuthenticationBloc bloc) async => bloc.add(AppStarted()));

    blocTest<AuthenticationBloc, AuthenticationEvent, AuthenticationState>(
        'Expect unauthenticated after Unauthenticate event',
        skip: 0,
        build: () async => authenticationBloc,
        act: (AuthenticationBloc bloc) async => bloc.add(Unauthenticate()),
        expect: <TypeMatcher<AuthenticationState>>[
          isA<Uninitialized>(),
          isA<Unauthenticated>()
        ]);
  });
}
