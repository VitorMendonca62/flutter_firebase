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
    _authControllerOutput.add(AuthLoadingState());

    if (event is LoginRequested || event is LoginWithGoogleRequested) {
      try {
        UserCredential? user;
        if (event is LoginRequested) {
          /*  user =  */ await _authRepository.login(event.email);
        }

        if (event is LoginWithGoogleRequested) {
          user = await _authRepository.loginWithGoogle();
        }

        final userModel = UserModel(
          id: user!.user!.uid,
          name: user.user!.displayName!,
          email: user.user!.email!,
          accessToken: user.credential!.accessToken!,
          isEmailVerified: user.user!.emailVerified,
        );
        _authRepository.saveUser(userModel);
      } catch (e) {
        return _authControllerOutput.add(
          AuthFailureState(
            exception: 'Erro ao realizar o login',
          ),
        );
      }
    }

    if (event is RegisterRequested) {
      await _authRepository.register(event.email);
    }

    _authControllerOutput.add(AuthLoadedState());
  }
}
