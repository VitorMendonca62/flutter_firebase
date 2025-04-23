part of 'photo_bloc.dart';

abstract class PhotoEvent {}

class AddPhoto extends PhotoEvent {
  final File photo;
  final List<File> photos;

  AddPhoto(this.photo, this.photos);
}

class RemovePhoto extends PhotoEvent {
  final File photo;
  final List<File> photos;

  RemovePhoto(this.photo, this.photos);
}

class PhotoRequested extends PhotoEvent {
  final File photo;
  final List<File> photos;

  PhotoRequested(this.photo, this.photos);
}
