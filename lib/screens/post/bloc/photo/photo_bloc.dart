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
      if (event is AddPhoto) {
        photo = event.photo;
        event.photos.add(photo);
        _photoControllerOutput
            .add(PhotoLoadedState(imageFile: photo, photos: event.photos));
      }

      if (event is RemovePhoto) {
        photo = event.photo;
        event.photos.remove(photo);
        _photoControllerOutput
            .add(PhotoLoadedState(imageFile: photo, photos: event.photos));
      }

      if (event is PhotoRequested) {
        await _photoRepository.updatePhoto(event.photo);
        _photoControllerOutput.add(PhotoSubmitedState(
          imageFile: event.photo,
          photos: event.photos,
        ));
      }
    } catch (e) {
      photo = null;
      _photoControllerOutput.add(PhotoFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
