import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/models/user/user_model.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.email);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LoginWithGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.loginWithGoogle();
        final userModel = UserModel(
          id: user.user!.uid,
          name: user.user!.displayName!,
          email: user.user!.email!,
          accessToken: user.credential!.accessToken!,
          isEmailVerified: user.user!.emailVerified,
        );
        authRepository.saveUser(userModel);
   
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // await authRepository.register(event.email);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
