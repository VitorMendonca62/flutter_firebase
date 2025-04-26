part of 'update_password_bloc.dart';

abstract class UpdatePasswordEvent {
  String? oldPassword;
  String? newPassword;

  UpdatePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}

class UpdatePasswordRequestedEvent extends UpdatePasswordEvent {
  UpdatePasswordRequestedEvent({
    required super.oldPassword,
    required super.newPassword,
  });
}
