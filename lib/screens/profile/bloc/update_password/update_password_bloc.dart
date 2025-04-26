import 'dart:async';

import 'package:flutter_firebase/screens/profile/repositories/user_repository.dart';

part 'update_password_event.dart';
part 'update_password_state.dart';

class UpdatePasswordBloc {
  final UserRepository _userRepository = UserRepository();

  final StreamController<UpdatePasswordEvent> _updatePasswordControllerInput =
      StreamController<UpdatePasswordEvent>();
  final StreamController<UpdatePasswordState> _updatePasswordControllerOutput =
      StreamController<UpdatePasswordState>();

  Sink<UpdatePasswordEvent> get updatePasswordInput =>
      _updatePasswordControllerInput.sink;
  Stream<UpdatePasswordState> get updatePasswordOutput =>
      _updatePasswordControllerOutput.stream;

  UpdatePasswordBloc() {
    _updatePasswordControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(UpdatePasswordEvent event) async {
    _updatePasswordControllerOutput.add(UpdatePasswordLoadingState());
    try {
      if (event is UpdatePasswordRequestedEvent) {
        await _userRepository.updatePassword(event.newPassword);
        _updatePasswordControllerOutput
            .add(UpdatePasswordSubmittedState(newPassword: event.newPassword));
      }
    } catch (e) {
      _updatePasswordControllerOutput.add(UpdatePasswordFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
      ));
    }
  }
}
