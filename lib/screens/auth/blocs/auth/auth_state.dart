part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {}

class AuthFailureState extends AuthState {
  final String exception;
  bool wasHandled = false;

  AuthFailureState({required this.exception});
}
