part of 'auth_bloc.dart';

abstract class AuthState {
  bool wasHandled;

  AuthState({required this.wasHandled});
}

class AuthInitialState extends AuthState {
  AuthInitialState() : super(wasHandled: false);
}

class AuthLoadingState extends AuthState {
  AuthLoadingState() : super(wasHandled: false);
}

class AuthSubmitedState extends AuthState {
  AuthSubmitedState() : super(wasHandled: false);
}

class AuthFailureState extends AuthState {
  final String exception;

  AuthFailureState({required this.exception}) : super(wasHandled: false);
}
