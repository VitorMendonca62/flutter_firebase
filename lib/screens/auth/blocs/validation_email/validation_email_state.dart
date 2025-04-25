part of 'validation_email_bloc.dart';

abstract class ValidationEmailState {
  bool wasHandled;

  ValidationEmailState({required this.wasHandled});
}

class ValidationEmailInitialState extends ValidationEmailState {
  ValidationEmailInitialState() : super(wasHandled: false);
}

class ValidationEmailLoadingState extends ValidationEmailState {
  ValidationEmailLoadingState() : super(wasHandled: false);
}

class ValidationEmailSubmitedState extends ValidationEmailState {
  ValidationEmailSubmitedState() : super(wasHandled: false);
}

class ValidationEmailFailureState extends ValidationEmailState {
  final String exception;

  ValidationEmailFailureState({required this.exception})
      : super(wasHandled: false);
}
