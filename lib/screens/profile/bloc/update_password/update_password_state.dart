part of 'update_password_bloc.dart';

abstract class UpdatePasswordState {
  final String? oldPassword;
  final String? newPassword;

  UpdatePasswordState({required this.oldPassword, required this.newPassword});
}

class UpdatePasswordInitialState extends UpdatePasswordState {
  UpdatePasswordInitialState() : super(oldPassword: null, newPassword: null);
}

class UpdatePasswordLoadingState extends UpdatePasswordState {
  UpdatePasswordLoadingState({
    required super.oldPassword,
    required super.newPassword,
  }) : super();
}

class UpdatePasswordSubmittedState extends UpdatePasswordState {
  UpdatePasswordSubmittedState({
    required super.oldPassword,
    required super.newPassword,
  }) : super();
}

class UpdatePasswordFailureState extends UpdatePasswordState {
  final String exception;

  UpdatePasswordFailureState({
    required this.exception,
    required super.oldPassword,
    required super.newPassword,
  });
}
