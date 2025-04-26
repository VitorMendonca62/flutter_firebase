import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_email/update_email_bloc.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class UpdateEmail extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailInputController;
  final UpdateEmailBloc updateEmailBloc;

  const UpdateEmail({
    super.key,
    required this.formKey,
    required this.emailInputController,
    required this.updateEmailBloc,
  });

  handleSubmited(UpdateEmailSubmittedState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Email atualizado com sucesso',
        context,
      );
      data.wasHandled = true;
    });
  }

  handleError(UpdateEmailFailureState data, context) {
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
      child: StreamBuilder<UpdateEmailState>(
        stream: updateEmailBloc.updateEmailOutput,
        initialData: UpdateEmailInitialState(),
        builder: (context, state) {
          final UpdateEmailState data = state.data!;
          if (data is UpdateEmailSubmittedState && !data.wasHandled) {
            handleSubmited(data, context);
          }
          if (data is UpdateEmailFailureState && !data.wasHandled) {
            handleError(data, context);
          }
          return Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "Atualizar Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: CapybaColors.black,
                  ),
                ),
                Text(
                  "Enviaremos um e-mail com um link de verificação para você. Para continuar, abra sua caixa de entrada, clique no link de confirmação, volte ao app e realize o login novamente. Assim que confirmar, seu acesso será liberado automaticamente e seu email estará atualizado. Caso não encontre, verifique também a pasta de spam ou lixo eletrônico.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: CapybaColors.gray2,
                  ),
                ),
                const SizedBox(height: 16),
                FormInput(
                  controller: emailInputController,
                  hintText: validEmail,
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidation,
                  obscureText: false,
                  minLines: 1,
                  maxLines: 1,
                  isDisabled: false,
                ),
                const SizedBox(height: 16),
                FormButton(
                  handleSubmit: () {
                    updateEmailBloc.updateEmailInput.add(
                      UpdateEmailRequestedEvent(
                        newEmail: emailInputController.text,
                      ),
                    );
                  },
                  formKey: formKey,
                  labelIsWidget: data is UpdateEmailLoadingState,
                  labelWidget: CircularProgressIndicator(
                    color: CapybaColors.white,
                  ),
                  labelString: "Atualizar",
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
