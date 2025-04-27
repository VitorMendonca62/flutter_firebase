part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState {
  bool wasHandled;

  ForgotPasswordState({required this.wasHandled});
}

class ForgotPasswordInitialState extends ForgotPasswordState {
  ForgotPasswordInitialState() : super(wasHandled: false);
}

class ForgotPasswordLoadingState extends ForgotPasswordState {
  ForgotPasswordLoadingState() : super(wasHandled: false);
}

class ForgotPasswordSubmitedState extends ForgotPasswordState {
  ForgotPasswordSubmitedState() : super(wasHandled: false);
}

class ForgotPasswordFailureState extends ForgotPasswordState {
  final String exception;

  ForgotPasswordFailureState({required this.exception})
      : super(wasHandled: false);
}
