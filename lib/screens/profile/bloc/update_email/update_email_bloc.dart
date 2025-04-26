import 'dart:async';

import 'package:flutter_firebase/screens/profile/repositories/user_repository.dart';

part 'update_email_event.dart';
part 'update_email_state.dart';

class UpdateEmailBloc {
  final UserRepository _userRepository = UserRepository();

  final StreamController<UpdateEmailEvent> _updateEmailControllerInput =
      StreamController<UpdateEmailEvent>();
  final StreamController<UpdateEmailState> _updateEmailControllerOutput =
      StreamController<UpdateEmailState>();

  Sink<UpdateEmailEvent> get updateEmailInput =>
      _updateEmailControllerInput.sink;
  Stream<UpdateEmailState> get updateEmailOutput =>
      _updateEmailControllerOutput.stream;

  UpdateEmailBloc() {
    _updateEmailControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(UpdateEmailEvent event) async {
    _updateEmailControllerOutput.add(UpdateEmailLoadingState());
    try {
      if (event is UpdateEmailRequestedEvent) {
        await _userRepository.updateEmail(event.newEmail);
        _updateEmailControllerOutput.add(UpdateEmailSubmittedState(
          newEmail: event.newEmail,
        ));
      }
    } catch (e) {
      _updateEmailControllerOutput.add(UpdateEmailFailureState(
        exception: e.toString().replaceAll("Exception: ", ''),
      ));
    }
  }
}
