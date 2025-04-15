import 'dart:async';
import 'dart:io';

import 'package:flutter_firebase/screens/auth/repositories/photo_repository.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc {
  final _photoRepository = PhotoRepository();

  final StreamController<PhotoEvent> _photoControllerInput =
      StreamController<PhotoEvent>();
  final StreamController<PhotoState> _photoControllerOutput =
      StreamController<PhotoState>();

  Sink<PhotoEvent> get photoInput => _photoControllerInput.sink;
  Stream<PhotoState> get photoOutput => _photoControllerOutput.stream;

  PhotoBloc() {
    _photoControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PhotoEvent event) async {
    late File? photo;
    _photoControllerOutput.add(PhotoLoadingState());
    try {
      if (event is PhotoUpdate) {
        photo = event.photo;
      }

      if (event is PhotoRequested) {
        photo = event.photo;
        await _photoRepository.updatePhoto(event.photo);
      }

      _photoControllerOutput.add(PhotoLoadedState(
        imageFile: photo!,
      ));
    } catch (e) {
      photo = null;
      _photoControllerOutput.add(PhotoFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
