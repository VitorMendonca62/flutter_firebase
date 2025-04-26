import 'dart:async';
import 'dart:io';

import 'package:flutter_firebase/screens/auth/repositories/photo_repository.dart';
import 'package:flutter_firebase/screens/profile/repositories/user_repository.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc {
  final _photoRepository = PhotoRepository();
  final _userRepository = UserRepository();

  final StreamController<UpdateUserEvent> _updateUserControllerInput =
      StreamController<UpdateUserEvent>();
  final StreamController<UpdateUserState> _updateUserControllerOutput =
      StreamController<UpdateUserState>();

  Sink<UpdateUserEvent> get updateUserInput => _updateUserControllerInput.sink;
  Stream<UpdateUserState> get updateUserOutput =>
      _updateUserControllerOutput.stream;

  UpdateUserBloc() {
    _updateUserControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(UpdateUserEvent event) async {
    _updateUserControllerOutput.add(UpdateUserLoadingState(
      imageFile: event.photo,
    ));
    try {
      if (event is PhotoUpdate) {
        _updateUserControllerOutput.add(UpdateUserLoadedState(
          imageFile: event.photo,
        ));
      }

      if (event is UpdateUseRequestedEvent) {
        String? photoUrl;
        if (event.photo != null) {
          photoUrl = await _photoRepository.uploadPhotoInImgur(event.photo!);
        }
        _userRepository.updateUser(
          event.displayName,
          photoUrl,
        );
        _updateUserControllerOutput.add(UpdateUserSubmittedState(
          imageFile: event.photo,
        ));
      }
    } catch (e) {
      _updateUserControllerOutput.add(UpdateUserFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
      ));
    }
  }
}
