import 'dart:async';

import 'package:flutter_firebase/screens/auth/repositories/auth_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc {
  final _authRepository = AuthRepository();

  final StreamController<ForgotPasswordEvent> _forgotPasswordControllerInput =
      StreamController<ForgotPasswordEvent>();
  final StreamController<ForgotPasswordState> _forgotPasswordControllerOutput =
      StreamController<ForgotPasswordState>();

  Sink<ForgotPasswordEvent> get forgotPasswordInput =>
      _forgotPasswordControllerInput.sink;
  Stream<ForgotPasswordState> get forgotPasswordOutput =>
      _forgotPasswordControllerOutput.stream;

  ForgotPasswordBloc() {
    _forgotPasswordControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ForgotPasswordEvent event) async {
    try {
      _forgotPasswordControllerOutput.add(ForgotPasswordLoadingState());
      if (event is ForgotPasswordRequestedEvent) {
        await _authRepository.forgotPassword(email: event.email);
        _forgotPasswordControllerOutput.add(ForgotPasswordSubmitedState());
      }
    } catch (e) {
      _forgotPasswordControllerOutput.add(ForgotPasswordFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
