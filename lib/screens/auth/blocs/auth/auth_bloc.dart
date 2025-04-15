import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/user/user_model.dart';
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
      _authControllerOutput.add(AuthLoadingState());

      UserCredential? user;
      if (event is LoginRequested) {
        user = await _authRepository.login(event.email, event.password);
      }

      if (event is LoginWithGoogleRequested) {
        user = await _authRepository.loginWithGoogle();
      }

      if (event is RegisterRequested) {
        user = await _authRepository.register(
            email: event.email, password: event.password, name: event.name);

        final userModel = UserModel(
          id: user.user!.uid,
          name: user.user!.displayName,
          email: user.user!.email!,
          accessToken: user.credential?.accessToken,
          isEmailVerified: user.user!.emailVerified,
          photoUrl: user.user!.photoURL,
        );
        _authRepository.saveUser(userModel);
      }

      _authControllerOutput.add(AuthLoadedState());
    } catch (e) {
      _authControllerOutput.add(AuthFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
