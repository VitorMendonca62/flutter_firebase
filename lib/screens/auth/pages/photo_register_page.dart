import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/photo/photo_bloc.dart';
import 'package:flutter_firebase/utils/photo.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class PhotoRegisterPage extends StatefulWidget {
  final bool canBack;
  const PhotoRegisterPage({
    super.key,
    required this.canBack,
  });

  @override
  State<PhotoRegisterPage> createState() => _PhotoRegisterPageState();
}

class _PhotoRegisterPageState extends State<PhotoRegisterPage> {
  late final PhotoBloc _photoBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _photoBloc = PhotoBloc();
    super.initState();
  }

  updatePhoto(String path) {
    return _photoBloc.photoInput.add(
      PhotoUpdate(
        photo: File(path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Adicione uma foto para seu perfil",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: CapybaColors.gray1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "( Esse passo é obrigatório )",
                    style: TextStyle(
                      fontSize: 16,
                      color: CapybaColors.gray2,
                    ),
                  ),
                  StreamBuilder<PhotoState>(
                    stream: _photoBloc.photoOutput,
                    initialData: PhotoInitialState(),
                    builder: (context, state) {
                      bool oldWasHandled = false;

                      if (state.data is PhotoFailureState &&
                          !state.data!.wasHandled) {
                        SnackBarNotification.error(
                          (state.data as PhotoFailureState).exception,
                          context,
                        );
                        oldWasHandled = state.data!.wasHandled;
                        state.data!.wasHandled = true;
                      }

                      if (state.data is PhotoSubmitedState &&
                          !state.data!.wasHandled) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          SnackBarNotification.success(
                            'Foto de perfil enviada com sucesso',
                            context,
                          );
                          Navigator.of(context).pushNamed(Routes.home);
                          state.data!.wasHandled = true;
                        });
                      }
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () => showImageSourceActionSheet(
                                context,
                                updatePhoto,
                              ),
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CapybaColors.gray2.withOpacity(0.1),
                                    border: Border.all(
                                      color: (state.data is PhotoFailureState &&
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
                                        Center(
                                          child: Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: CapybaColors.capybaGreen,
                                          ),
                                        ),
                                      if (state.data is PhotoLoadingState)
                                        const SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: CircularProgressIndicator(),
                                        ),
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 40),
                            FormButton(
                              handleSubmit: () {
                                state.data?.imageFile != null
                                    ? _photoBloc.photoInput.add(
                                        PhotoRequested(
                                          photo: state.data!.imageFile!,
                                        ),
                                      )
                                    : null;
                              },
                              formKey: _formKey,
                              label: "Enviar",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
