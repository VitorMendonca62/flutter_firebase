part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {}

class ForgotPasswordRequestedEvent extends ForgotPasswordEvent {
  final String email;

  ForgotPasswordRequestedEvent({required this.email});
}
