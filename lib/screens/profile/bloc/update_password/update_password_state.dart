part of 'update_password_bloc.dart';

abstract class UpdatePasswordState {
  final String? newPassword;
  bool wasHandled;

  UpdatePasswordState({
    required this.newPassword,
    required this.wasHandled,
  });
}

class UpdatePasswordInitialState extends UpdatePasswordState {
  UpdatePasswordInitialState()
      : super(
          newPassword: null,
          wasHandled: false,
        );
}

class UpdatePasswordLoadingState extends UpdatePasswordState {
  UpdatePasswordLoadingState()
      : super(
          newPassword: null,
          wasHandled: false,
        );
}

class UpdatePasswordSubmittedState extends UpdatePasswordState {
  UpdatePasswordSubmittedState({
    required super.newPassword,
  }) : super(
          wasHandled: false,
        );
}

class UpdatePasswordFailureState extends UpdatePasswordState {
  final String exception;

  UpdatePasswordFailureState({
    required this.exception,
  }) : super(
          newPassword: null,
          wasHandled: false,
        );
}
