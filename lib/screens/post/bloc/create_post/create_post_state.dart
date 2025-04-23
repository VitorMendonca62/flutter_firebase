part of 'create_post_bloc.dart';

abstract class CreatePostState {
  final File? photo;
  bool wasHandled;
  List<File> photos;

  CreatePostState({
    required this.photo,
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
        );
}

class CreatePostLoadingState extends CreatePostState {
  CreatePostLoadingState()
      : super(
          photo: null,
          wasHandled: false,
          photos: [],
        );
}

class CreatePostLoadedState extends CreatePostState {
  CreatePostLoadedState({
    required File super.photo,
    required super.photos,
  }) : super(
          wasHandled: false,
        );
}

class CreatePostSubmitedState extends CreatePostState {
  CreatePostSubmitedState({
    required super.photos,
  }) : super(
          wasHandled: false,
          photo: null,
        );
}

class CreatePostFailureState extends CreatePostState {
  final String exception;

  CreatePostFailureState({required this.exception})
      : super(
          photo: null,
          wasHandled: false,
          photos: [],
        );
}
