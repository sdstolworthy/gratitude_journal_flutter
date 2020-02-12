import 'package:meta/meta.dart';

@immutable
abstract class LoginScreenEvent {}

class LogIn extends LoginScreenEvent {
  LogIn(this.username, this.password);

  final String password;
  final String username;
}

class SignUp extends LoginScreenEvent {
  SignUp(this.username, this.password);

  final String password;
  final String username;
}

class AuthWithGoogle extends LoginScreenEvent {}