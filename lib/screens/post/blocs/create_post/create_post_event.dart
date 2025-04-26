part of 'create_post_bloc.dart';

abstract class CreatePostEvent {
  final List<File> photos;
  final bool isRestrict;

  const CreatePostEvent({
    required this.isRestrict,
    required this.photos,
  });
}

class AddPhoto extends CreatePostEvent {
  final File photo;

  AddPhoto({
    required this.photo,
    required super.photos,
    required super.isRestrict,
  });
}

class ChangeSwitch extends CreatePostEvent {
  ChangeSwitch({
    required super.photos,
    required super.isRestrict,
  });
}

class RemovePhoto extends CreatePostEvent {
  final int index;

  RemovePhoto({
    required this.index,
    required super.photos,
    required super.isRestrict,
  });
}

class CreatePostRequested extends CreatePostEvent {
  final String title;
  final String content;

  CreatePostRequested({
    required this.title,
    required this.content,
    required super.photos,
    required super.isRestrict,
  });
}
