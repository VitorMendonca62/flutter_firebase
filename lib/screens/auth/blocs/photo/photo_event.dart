part of 'photo_bloc.dart';

abstract class PhotoEvent {}

class PhotoUpdate extends PhotoEvent {
  final File photo;

  PhotoUpdate(this.photo);
}

class PhotoRequested extends PhotoEvent {
  final File photo;

  PhotoRequested(this.photo);
}
