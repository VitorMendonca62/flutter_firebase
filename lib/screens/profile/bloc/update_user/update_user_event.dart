part of 'update_user_bloc.dart';

abstract class UpdateUserEvent {
  final File? photo;

  const UpdateUserEvent(
    this.photo,
  );
}

class UpdateUseRequestedEvent extends UpdateUserEvent {
  final String displayName;

  const UpdateUseRequestedEvent({
    required this.displayName,
    required File? photo,
  }) : super(photo);
}

class PhotoUpdate extends UpdateUserEvent {
  PhotoUpdate({required File? photo}) : super(photo);
}
