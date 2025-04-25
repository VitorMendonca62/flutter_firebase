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
    _updateUserControllerOutput.add(UpdateUserLoadingState());
    try {
      if (event is UpdateUseRequestedEvent) {
        final String photoUrl =
            await _photoRepository.uploadPhotoInImgur(event.photo);
        _userRepository.updateUser(
          event.displayName,
          photoUrl,
        );
        _updateUserControllerOutput.add(UpdateUserSubmitedState());
      }
    } catch (e) {
      _updateUserControllerOutput.add(UpdateUserFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
      ));
    }
  }
}
