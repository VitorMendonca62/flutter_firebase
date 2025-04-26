part of 'update_user_bloc.dart';

abstract class UpdateUserState {
  bool wasHandled;
  File? imageFile;

  UpdateUserState({required this.wasHandled, required this.imageFile});
}

class UpdateUserInitialState extends UpdateUserState {
  UpdateUserInitialState({
    super.wasHandled = false,
    super.imageFile,
  });
}

class UpdateUserLoadingState extends UpdateUserState {
  UpdateUserLoadingState({required super.imageFile})
      : super(
          wasHandled: false,
        );
}

class UpdateUserLoadedState extends UpdateUserState {
  UpdateUserLoadedState({required super.imageFile})
      : super(
          wasHandled: false,
        );
}

class UpdateUserSubmittedState extends UpdateUserState {
  UpdateUserSubmittedState({
    required super.imageFile,
  }) : super(
          wasHandled: false,
        );
}

class UpdateUserFailureState extends UpdateUserState {
  final String exception;

  UpdateUserFailureState({
    required this.exception,
    super.wasHandled = false,
    super.imageFile,
  });
}
