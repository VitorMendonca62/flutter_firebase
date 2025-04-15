part of 'photo_bloc.dart';

@immutable
abstract class PhotoEvent {}

class PhotoRequested extends PhotoEvent {
  final File file;

  PhotoRequested(this.file);
}
