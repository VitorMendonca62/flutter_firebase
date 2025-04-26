part of 'update_email_bloc.dart';

abstract class UpdateEmailState {
  final String? newEmail;
  bool wasHandled;

  UpdateEmailState({
    required this.newEmail,
    required this.wasHandled,
  });
}

class UpdateEmailInitialState extends UpdateEmailState {
  UpdateEmailInitialState()
      : super(
          newEmail: null,
          wasHandled: false,
        );
}

class UpdateEmailLoadingState extends UpdateEmailState {
  UpdateEmailLoadingState()
      : super(
          newEmail: null,
          wasHandled: false,
        );
}

class UpdateEmailSubmittedState extends UpdateEmailState {
  UpdateEmailSubmittedState({
    required super.newEmail,
  }) : super(
          wasHandled: false,
        );
}

class UpdateEmailFailureState extends UpdateEmailState {
  final String exception;

  UpdateEmailFailureState({
    required this.exception,
  }) : super(
          newEmail: "",
          wasHandled: false,
        );
}
