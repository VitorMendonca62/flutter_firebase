part of 'create_post_bloc.dart';

abstract class CreatePostState {
  final File? photo;
  bool wasHandled;
  bool isRestrict;
  List<File> photos;

  CreatePostState({
    required this.photo,
    required this.isRestrict,
    required this.photos,
    required this.wasHandled,
  });
}

class CreatePostInitialState extends CreatePostState {
  CreatePostInitialState()
      : super(
          photo: null,
          wasHandled: false,
          photos: [],
          isRestrict: false,
        );
}

class CreatePostLoadingState extends CreatePostState {
  CreatePostLoadingState({
    required super.photos,
    required super.isRestrict,
  }) : super(
          photo: null,
          wasHandled: false,
        );
}

class CreatePostLoadedState extends CreatePostState {
  CreatePostLoadedState({
    required super.photos,
    required super.isRestrict,
  }) : super(
          photo: null,
          wasHandled: false,
        );
}

class CreatePostSubmitedState extends CreatePostState {
  CreatePostSubmitedState({
    required super.photos,
    required super.isRestrict,
  }) : super(
          wasHandled: false,
          photo: null,
        );
}

class CreatePostFailureState extends CreatePostState {
  final String exception;

  CreatePostFailureState({
    required this.exception,
    required super.photos,
    required super.isRestrict,
  }) : super(
          photo: null,
          wasHandled: false,
        );
}
