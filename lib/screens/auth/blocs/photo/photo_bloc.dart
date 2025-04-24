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
    _photoControllerOutput.add(PhotoLoadingState(imageFile: event.photo));
    try {
      if (event is PhotoUpdate) {
        _photoControllerOutput.add(PhotoLoadedState(
          imageFile: event.photo,
        ));
      }

      if (event is PhotoRequested) {
        await _photoRepository.updatePhoto(event.photo);
        _photoControllerOutput.add(PhotoSubmitedState(
          imageFile: event.photo,
        ));
      }
    } catch (e) {
      _photoControllerOutput.add(PhotoFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
