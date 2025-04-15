part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;

  LoginRequested({required this.email});
}

class LoginWithGoogleRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String email;
  final String name;

  RegisterRequested({
    required this.email,
    required this.name,
  });
}
