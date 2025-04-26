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
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController nameInputController = TextEditingController();
  final TextEditingController newPasswordInputController =
      TextEditingController();
  final TextEditingController oldConfirmPasswordInputController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late final UpdateUserBloc updateUserBloc;
  late final UpdatePasswordBloc updatePasswordBloc;

  @override
  void initState() {
    updateUserBloc = UpdateUserBloc();
    updatePasswordBloc = UpdatePasswordBloc();
    final User user = FirebaseAuth.instance.currentUser!;
    emailInputController.text = user.email!;
    nameInputController.text = user.displayName!;

    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                StreamBuilder<UpdateUserState>(
                    stream: updateUserBloc.updateUserOutput,
                    initialData: UpdateUserInitialState(wasHandled: false),
                    builder: (context, state) {
                      bool oldWasHandled = false;
                      if (state.data is UpdateUserSubmittedState &&
                          !state.data!.wasHandled) {
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
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Editar perfil",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: CapybaColors.gray1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => showImageSourceActionSheet(
                                  context,
                                  state.data?.imageFile != null,
                                  state.data?.imageFile != null
                                      ? deletePhoto
                                      : updatePhoto,
                                  false),
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CapybaColors.gray2.withOpacity(0.1),
                                  border: Border.all(
                                    color:
                                        (state.data is UpdateUserFailureState &&
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
                                          FirebaseAuth
                                              .instance.currentUser!.photoURL!,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nome inválido';
                                }
                                return null;
                              },
                              obscureText: false,
                              minLines: 1,
                              maxLines: 1,
                              isDisabled: false,
                            ),
                            const SizedBox(height: 12),
                            FormInput(
                              controller: emailInputController,
                              hintText: 'seu.email@exemplo.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidation,
                              obscureText: false,
                              labelText: 'Email',
                              minLines: 1,
                              isDisabled: true,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 12),
                            FormButton(
                              handleSubmit: () {
                                updateUserBloc.updateUserInput.add(
                                  UpdateUseRequestedEvent(
                                    displayName: nameInputController.text,
                                    photo: state.data?.imageFile,
                                  ),
                                );
                              },
                              formKey: _formKey,
                              labelIsWidget:
                                  state.data is UpdateUserLoadingState,
                              labelWidget: CircularProgressIndicator(
                                color: CapybaColors.white,
                              ),
                              labelString: "Editar",
                            )
                          ],
                        ),
                      );
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Divider(),
                ),
                Visibility(
                  visible: !FirebaseAuth.instance.currentUser!.providerData.any(
                    (provider) => provider.providerId == "google.com",
                  ),
                  child: StreamBuilder<UpdatePasswordState>(
                      stream: updatePasswordBloc.updatePasswordOutput,
                      initialData: UpdatePasswordInitialState(),
                      builder: (context, state) {
                        if (state.data is UpdatePasswordSubmittedState &&
                            !state.data!.wasHandled) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            SnackBarNotification.success(
                              'Senha atualizada com sucesso',
                              context,
                            );
                            state.data!.wasHandled = true;
                          });
                        }
                        return Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              Text(
                                "Atualizar senha",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  color: CapybaColors.gray1,
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
                                controller: oldConfirmPasswordInputController,
                                hintText: "*******",
                                labelText: "Confirmação da nova senha",
                                keyboardType: TextInputType.text,
                                validator: (String? value) =>
                                    confirmPasswordValidation(
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
                                      newPassword:
                                          newPasswordInputController.text,
                                    ),
                                  );
                                },
                                formKey: _passwordFormKey,
                                labelIsWidget:
                                    state.data is UpdateUserLoadingState,
                                labelWidget: CircularProgressIndicator(
                                  color: CapybaColors.white,
                                ),
                                labelString: "Atualizar",
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
