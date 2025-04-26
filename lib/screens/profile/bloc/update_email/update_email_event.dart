part of 'update_email_bloc.dart';

abstract class UpdateEmailEvent {
  String newEmail;

  UpdateEmailEvent({
    required this.newEmail,
  });
}

class UpdateEmailRequestedEvent extends UpdateEmailEvent {
  UpdateEmailRequestedEvent({
    required super.newEmail,
  });
}
