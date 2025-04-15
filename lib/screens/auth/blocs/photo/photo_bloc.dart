import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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
    late File photo;
    _photoControllerOutput.add(const PhotoLoadingState());

    if (event is PhotoRequested) {
      photo = event.photo;
      await _photoRepository.updatePhoto(event.photo);
    }

    _photoControllerOutput.add(PhotoSuccessState(
      imageFile: photo,
    ));
  }
}
