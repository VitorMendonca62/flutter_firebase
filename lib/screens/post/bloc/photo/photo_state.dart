part of 'photo_bloc.dart';

abstract class PhotoState {
  final File? imageFile;
  bool wasHandled;
  List<File> photos;

  PhotoState({
    required this.imageFile,
    required this.photos,
    required this.wasHandled,
  });
}

class PhotoInitialState extends PhotoState {
  PhotoInitialState()
      : super(
          imageFile: null,
          wasHandled: false,
          photos: [],
        );
}

class PhotoLoadingState extends PhotoState {
  PhotoLoadingState()
      : super(
          imageFile: null,
          wasHandled: false,
          photos: [],
        );
}

class PhotoLoadedState extends PhotoState {
  PhotoLoadedState({required File super.imageFile, required super.photos})
      : super(
          wasHandled: false,
        );
}

class PhotoSubmitedState extends PhotoState {
  PhotoSubmitedState({required File super.imageFile, required super.photos})
      : super(
          wasHandled: false,
        );
}

class PhotoFailureState extends PhotoState {
  final String exception;

  PhotoFailureState({required this.exception})
      : super(
          imageFile: null,
          wasHandled: false,
          photos: [],
        );
}
