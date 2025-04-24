import 'dart:async';

import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc {
  final _authRepository = AuthRepository();

  final StreamController<AuthEvent> _authControllerInput =
      StreamController<AuthEvent>();
  final StreamController<AuthState> _authControllerOutput =
      StreamController<AuthState>();

  Sink<AuthEvent> get authInput => _authControllerInput.sink;
  Stream<AuthState> get authOutput => _authControllerOutput.stream;

  AuthBloc() {
    _authControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(AuthEvent event) async {
    try {
      if (event is! LoginWithGoogleRequested) {
        _authControllerOutput.add(AuthLoadingState());
      }

      if (event is LoginRequested) {
        await _authRepository.login(event.email, event.password);
      }

      if (event is LoginWithGoogleRequested) {
        await _authRepository.loginWithGoogle();
      }

      if (event is RegisterRequested) {
        await _authRepository.register(
          email: event.email,
          password: event.password,
          name: event.name,
        );
      }

      _authControllerOutput.add(AuthSubmitedState());
    } catch (e) {
      _authControllerOutput.add(AuthFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
