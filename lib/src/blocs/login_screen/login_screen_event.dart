import 'package:meta/meta.dart';

@immutable
abstract class LoginScreenEvent {}

class RequiresUserToBeSignedOut {}

class LogIn extends LoginScreenEvent implements RequiresUserToBeSignedOut {
  LogIn(this.username, this.password);

  final String password;
  final String username;
}

class SignUp extends LoginScreenEvent implements RequiresUserToBeSignedOut {
  SignUp(this.username, this.password);

  final String password;
  final String username;
}

class AuthWithGoogle extends LoginScreenEvent
    implements RequiresUserToBeSignedOut {}
