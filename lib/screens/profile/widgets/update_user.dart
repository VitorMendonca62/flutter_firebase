import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_password/update_password_bloc.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_user/update_user_bloc.dart';
import 'package:flutter_firebase/utils/photo.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class UpdateUser extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameInputController;
  final UpdateUserBloc updateUserBloc;

  const UpdateUser({
    super.key,
    required this.formKey,
    required this.nameInputController,
    required this.updateUserBloc,
  });

  updatePhoto(String path) {
    return updateUserBloc.updateUserInput.add(
      PhotoUpdate(
        photo: File(path),
      ),
    );
  }

  deletePhoto(String path) {
    return updateUserBloc.updateUserInput.add(
      PhotoUpdate(
        photo: null,
      ),
    );
  }

  handleSubmited(UpdatePasswordSubmittedState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Usuário atualizado com sucesso',
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
    return StreamBuilder<UpdateUserState>(
      stream: updateUserBloc.updateUserOutput,
      initialData: UpdateUserInitialState(wasHandled: false),
      builder: (context, state) {
        bool oldWasHandled = false;
        if (state.data is UpdateUserSubmittedState && !state.data!.wasHandled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBarNotification.success(
              'Usuário alterado com sucesso',
              context,
            );
            oldWasHandled = state.data!.wasHandled;
            state.data!.wasHandled = true;
            state.data?.imageFile = null;
          });
        }
        return Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                "Editar perfil",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: CapybaColors.black,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => showImageSourceActionSheet(
                    context,
                    state.data?.imageFile != null,
                    state.data?.imageFile != null ? deletePhoto : updatePhoto,
                    false),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CapybaColors.gray2.withOpacity(0.1),
                    border: Border.all(
                      color: (state.data is UpdateUserFailureState &&
                              !oldWasHandled)
                          ? CapybaColors.red
                          : CapybaColors.capybaGreen,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (state.data?.imageFile != null)
                        ClipOval(
                          child: Image.file(
                            state.data!.imageFile!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        ClipOval(
                          child: Image.network(
                            FirebaseAuth.instance.currentUser!.photoURL!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (state.data is UpdateUserLoadingState)
                        const SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(),
                        ),
                      Positioned(
                        right: 25,
                        top: 1,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: CapybaColors.capybaGreen,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: CapybaColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormInput(
                controller: nameInputController,
                hintText: "Seu nome completo",
                labelText: "Nome",
                keyboardType: TextInputType.text,
                validator: nameValidation,
                obscureText: false,
                minLines: 1,
                maxLines: 1,
                isDisabled: false,
              ),
              const SizedBox(height: 16),
              FormButton(
                handleSubmit: () {
                  updateUserBloc.updateUserInput.add(
                    UpdateUseRequestedEvent(
                      displayName: nameInputController.text,
                      photo: state.data?.imageFile,
                    ),
                  );
                },
                formKey: formKey,
                labelIsWidget: state.data is UpdateUserLoadingState,
                labelWidget: CircularProgressIndicator(
                  color: CapybaColors.white,
                ),
                labelString: "Editar",
              )
            ],
          ),
        );
      },
    );
  }
}
