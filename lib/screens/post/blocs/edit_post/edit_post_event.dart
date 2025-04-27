part of 'edit_post_bloc.dart';

abstract class EditPostEvent {
  final List<dynamic> photos;
  List<File>? newPhotos;
  final bool isRestrict;

  EditPostEvent({
    required this.isRestrict,
    required this.photos,
    required this.newPhotos,
  });
}

class AddPhoto extends EditPostEvent {
  final File photo;

  AddPhoto({
    required this.photo,
    required super.photos,
    required super.newPhotos,
    required super.isRestrict,
  });
}


class RemovePhoto extends EditPostEvent {
  final int index;
  final bool isNewPhoto;

  RemovePhoto({
    required this.isNewPhoto,
    required this.index,
    required super.newPhotos,
    required super.photos,
    required super.isRestrict,
  });
}

class EditPostRequested extends EditPostEvent {
  final String? title;
  final String? content;
  final String postId;


  EditPostRequested({
    required this.postId,
    required this.title,
    required super.newPhotos,
    required this.content,
    required super.photos,
    required super.isRestrict,
  });
}
