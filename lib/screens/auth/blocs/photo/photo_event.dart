part of 'photo_bloc.dart';

abstract class PhotoEvent {}

class PhotoRequested extends PhotoEvent {
  final File photo;

  PhotoRequested(this.photo);
}
