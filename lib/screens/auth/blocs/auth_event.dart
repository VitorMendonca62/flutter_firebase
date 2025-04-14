part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;

  LoginRequested(this.email);
}

class LoginWithGoogleRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  RegisterRequested(this.email, this.password);
}
