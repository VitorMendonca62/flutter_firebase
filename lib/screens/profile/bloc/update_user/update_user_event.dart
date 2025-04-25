part of 'update_user_bloc.dart';

abstract class UpdateUserEvent {
  final String displayName;
  final File photo;

  const UpdateUserEvent(
    this.displayName,
    this.photo,
  );
}

class UpdateUseRequestedEvent extends UpdateUserEvent {
  const UpdateUseRequestedEvent(
    super.displayName,
    super.photo,
  );
}
