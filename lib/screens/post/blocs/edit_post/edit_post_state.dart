part of 'edit_post_bloc.dart';

abstract class EditPostState {
  final File? photo;
  bool wasHandled;
  bool isRestrict;
  List<dynamic> photos;
  List<File>? newPhotos;

  EditPostState({
    required this.photo,
    required this.isRestrict,
    required this.photos,
    required this.newPhotos,
    required this.wasHandled,
  });
}

class EditPostInitialState extends EditPostState {
  EditPostInitialState({
    required super.photos,
  }) : super(
            photo: null, wasHandled: false, isRestrict: false, newPhotos: null);
}

class EditPostLoadingState extends EditPostState {
  EditPostLoadingState({
    required super.photos,
    required super.newPhotos,
    required super.isRestrict,
  }) : super(
          photo: null,
          wasHandled: false,
        );
}

class EditPostLoadedState extends EditPostState {
  EditPostLoadedState({
    required super.photos,
    required super.isRestrict,
    required super.newPhotos,
  }) : super(
          photo: null,
          wasHandled: false,
        );
}

class EditPostSubmitedState extends EditPostState {
  EditPostSubmitedState({
    required super.photos,
    required super.isRestrict,
    required super.newPhotos,
  }) : super(
          wasHandled: false,
          photo: null,
        );
}

class EditPostFailureState extends EditPostState {
  final String exception;

  EditPostFailureState({
    required this.exception,
    required super.photos,
    required super.isRestrict,
    required super.newPhotos,
  }) : super(
          photo: null,
          wasHandled: false,
        );
}
