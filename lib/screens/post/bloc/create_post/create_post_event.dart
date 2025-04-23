part of 'create_post_bloc.dart';

abstract class CreatePostEvent {}

class AddPhoto extends CreatePostEvent {
  final File photo;
  final List<File> photos;

  AddPhoto(this.photo, this.photos);
}

class RemovePhoto extends CreatePostEvent {
  final File photo;
  final List<File> photos;

  RemovePhoto(this.photo, this.photos);
}

class CreatePostRequested extends CreatePostEvent {
  final String title;
  final String content;
  final List<File> photos;

  CreatePostRequested({
    required this.title,
    required this.content,
    required this.photos,
  });
}
