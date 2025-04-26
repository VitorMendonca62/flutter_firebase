part of 'update_password_bloc.dart';

abstract class UpdatePasswordEvent {
  String newPassword;

  UpdatePasswordEvent({
    required this.newPassword,
  });
}

class UpdatePasswordRequestedEvent extends UpdatePasswordEvent {
  UpdatePasswordRequestedEvent({
    required super.newPassword,
  });
}
