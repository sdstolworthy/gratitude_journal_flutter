import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class RequiresBiometricsForAuthentication extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}
