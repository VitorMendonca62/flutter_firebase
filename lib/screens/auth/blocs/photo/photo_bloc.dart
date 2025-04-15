import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/models/user/user_model.dart';
import 'package:flutter_firebase/screens/auth/repositories/photo_repository.dart';
import '../../repositories/auth_repository.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository photoRepository;

  PhotoBloc(this.photoRepository) : super(PhotoInitial()) {
    on<PhotoRequested>((event, emit) async {
      emit(PhotoLoading());
      try {
        await photoRepository.updatePhoto(event.file);
        emit(PhotoSuccess());
      } catch (e) {
        emit(PhotoFailure(e.toString()));
      }
    });
  }
}
