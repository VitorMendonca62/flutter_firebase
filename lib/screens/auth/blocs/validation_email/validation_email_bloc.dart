import 'dart:async';

import '../../repositories/validation_email_repository.dart';

part 'validation_email_event.dart';
part 'validation_email_state.dart';

class ValidationEmailBloc {
  final _validationEmailRepository = ValidationEmailRepository();

  final StreamController<ValidationEmailEvent> _validationEmailControllerInput =
      StreamController<ValidationEmailEvent>();
  final StreamController<ValidationEmailState>
      _validationEmailControllerOutput =
      StreamController<ValidationEmailState>();

  Sink<ValidationEmailEvent> get validationEmailInput =>
      _validationEmailControllerInput.sink;
  Stream<ValidationEmailState> get validationEmailOutput =>
      _validationEmailControllerOutput.stream;

  ValidationEmailBloc() {
    _validationEmailControllerInput.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ValidationEmailEvent event) async {
    try {
      _validationEmailControllerOutput.add(ValidationEmailLoadingState());
      if (event is ValidationEmailRequestedEvent) {
        _validationEmailRepository.validateEmail();
        _validationEmailControllerOutput.add(ValidationEmailSubmitedState());
      }
    } catch (e) {
      _validationEmailControllerOutput.add(ValidationEmailFailureState(
          exception: e.toString().replaceAll("Exception: ", '')));
    }
  }
}
