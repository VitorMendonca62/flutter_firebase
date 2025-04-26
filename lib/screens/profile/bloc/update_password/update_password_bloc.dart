import 'dart:async';
import 'dart:io';

import 'package:flutter_firebase/screens/auth/repositories/photo_repository.dart';
import 'package:flutter_firebase/screens/profile/repositories/user_repository.dart';

part 'update_password_event.dart';
part 'update_password_state.dart';

class UpdatePasswordBloc {
  final _photoRepository = PhotoRepository();
  final _userRepository = UserRepository();

  final StreamController<UpdatePasswordEvent> _updatePasswordControllerInput =
      StreamController<UpdatePasswordEvent>();
  final StreamController<UpdatePasswordState> _updatePasswordControllerOutput =
      StreamController<UpdatePasswordState>();

  Sink<UpdatePasswordEvent> get updatePasswordInput => _updatePasswordControllerInput.sink;
  Stream<UpdatePasswordState> get updatePasswordOutput =>
      _updatePasswordControllerOutput.stream;

  UpdatePasswordBloc() {
    _updatePasswordControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(UpdatePasswordEvent event) async {
    _updatePasswordControllerOutput.add(UpdatePasswordLoadingState(
      imageFile: event.photo,
    ));
    try {
      if (event is PhotoUpdate) {
        _updatePasswordControllerOutput.add(UpdatePasswordLoadedState(
          imageFile: event.photo,
        ));
      }

      if (event is UpdateUseRequestedEvent) {
        String? photoUrl;
        if (event.photo != null) {
          photoUrl = await _photoRepository.uploadPhotoInImgur(event.photo!);
        }
        _userRepository.updatePassword(
          event.displayName,
          photoUrl,
        );
        _updatePasswordControllerOutput.add(UpdatePasswordSubmittedState(
          imageFile: event.photo,
        ));
      }
    } catch (e) {
      _updatePasswordControllerOutput.add(UpdatePasswordFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
      ));
    }
  }
}
