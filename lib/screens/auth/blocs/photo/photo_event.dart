part of 'photo_bloc.dart';

abstract class PhotoEvent {
  final File? photo;

  PhotoEvent(this.photo);
}

class PhotoUpdate extends PhotoEvent {
  PhotoUpdate({required File? photo}) : super(photo);
}

class PhotoRequested extends PhotoEvent {
  PhotoRequested({required File? photo}) : super(photo);
}
