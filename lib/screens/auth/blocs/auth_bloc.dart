import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.register(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
