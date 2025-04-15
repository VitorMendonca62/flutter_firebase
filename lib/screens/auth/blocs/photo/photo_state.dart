part of 'photo_bloc.dart';

@immutable
abstract class PhotoState {
  final File? imageFile;

  const PhotoState({required this.imageFile});
}

class PhotoInitialState extends PhotoState {
  const PhotoInitialState() : super(imageFile: null);
}

class PhotoLoadingState extends PhotoState {
  const PhotoLoadingState() : super(imageFile: null);
}

class PhotoSuccessState extends PhotoState {
  const PhotoSuccessState({required File imageFile}) : super(imageFile: imageFile);
}

class PhotoFailureState extends PhotoState {
  final String exception;

  const PhotoFailureState({required this.exception}) : super(imageFile: null);
}
