import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_password/update_password_bloc.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class UpdatePassword extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordInputController;
  final TextEditingController confirmNewPasswordInputController;
  final UpdatePasswordBloc updatePasswordBloc;

  const UpdatePassword({
    super.key,
    required this.formKey,
    required this.newPasswordInputController,
    required this.confirmNewPasswordInputController,
    required this.updatePasswordBloc,
  });

  handleSubmited(UpdatePasswordSubmittedState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Senha atualizada com sucesso',
        context,
      );
      data.wasHandled = true;
    });
  }

  handleError(UpdatePasswordFailureState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        data.exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !FirebaseAuth.instance.currentUser!.providerData.any(
        (provider) => provider.providerId == "google.com",
      ),
      child: StreamBuilder<UpdatePasswordState>(
          stream: updatePasswordBloc.updatePasswordOutput,
          initialData: UpdatePasswordInitialState(),
          builder: (context, state) {
            final UpdatePasswordState data = state.data!;

            if (data is UpdatePasswordSubmittedState && !data.wasHandled) {
              handleSubmited(data, context);
            }
            if (data is UpdatePasswordFailureState && !data.wasHandled) {
              handleError(data, context);
            }
            return Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Atualizar senha",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: CapybaColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormInput(
                    controller: newPasswordInputController,
                    hintText: "*******",
                    labelText: "Nova senha",
                    keyboardType: TextInputType.text,
                    validator: passwordValidation,
                    obscureText: true,
                    minLines: 1,
                    maxLines: 1,
                    isDisabled: false,
                  ),
                  const SizedBox(height: 12),
                  FormInput(
                    controller: confirmNewPasswordInputController,
                    hintText: "*******",
                    labelText: "Confirmação da nova senha",
                    keyboardType: TextInputType.text,
                    validator: (String? value) => confirmPasswordValidation(
                      newPasswordInputController.text,
                      value,
                    ),
                    obscureText: true,
                    minLines: 1,
                    maxLines: 1,
                    isDisabled: false,
                  ),
                  const SizedBox(height: 12),
                  FormButton(
                    handleSubmit: () {
                      updatePasswordBloc.updatePasswordInput.add(
                        UpdatePasswordRequestedEvent(
                          newPassword: newPasswordInputController.text,
                        ),
                      );
                    },
                    formKey: formKey,
                    labelIsWidget: state.data is UpdatePasswordLoadingState,
                    labelWidget: CircularProgressIndicator(
                      color: CapybaColors.white,
                    ),
                    labelString: "Editar",
                  )
                ],
              ),
            );
          }),
    );
  }
}
