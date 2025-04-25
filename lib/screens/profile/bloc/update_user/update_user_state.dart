part of 'update_user_bloc.dart';

abstract class UpdateUserState {
  UpdateUserState();
}

class UpdateUserInitialState extends UpdateUserState {
  UpdateUserInitialState();
}

class UpdateUserLoadingState extends UpdateUserState {
  UpdateUserLoadingState();
}

class UpdateUserLoadedState extends UpdateUserState {
  UpdateUserLoadedState();
}

class UpdateUserSubmitedState extends UpdateUserState {
  UpdateUserSubmitedState();
}

class UpdateUserFailureState extends UpdateUserState {
  final String exception;

  UpdateUserFailureState({
    required this.exception,
  });
}
