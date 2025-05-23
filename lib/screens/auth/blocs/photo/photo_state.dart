part of 'photo_bloc.dart';

abstract class PhotoState {
  final File? imageFile;
  bool wasHandled;

  PhotoState({required this.imageFile, required this.wasHandled});
}

class PhotoInitialState extends PhotoState {
  PhotoInitialState() : super(imageFile: null, wasHandled: false);
}

class PhotoLoadingState extends PhotoState {
  PhotoLoadingState({required super.imageFile})
      : super(wasHandled: false);
}

class PhotoLoadedState extends PhotoState {
  PhotoLoadedState({required super.imageFile})
      : super(wasHandled: false);
}

class PhotoSubmitedState extends PhotoState {
  PhotoSubmitedState({required super.imageFile})
      : super(wasHandled: false);
}

class PhotoFailureState extends PhotoState {
  final String exception;

  PhotoFailureState({required this.exception})
      : super(imageFile: null, wasHandled: false);
}
