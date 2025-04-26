import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/photo/photo_bloc.dart';
import 'package:flutter_firebase/utils/orthers.dart';
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

  deletePhoto(String path) {
    return _photoBloc.photoInput.add(
      PhotoUpdate(
        photo: null,
      ),
    );
  }

  handleError(PhotoState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        (data as PhotoFailureState).exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  handleSubmited(PhotoState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Foto de perfil enviada com sucesso',
        context,
      );
      goTo(Routes.home, context);
      data.wasHandled = true;
    });
  }

  handleRegister(PhotoState data, BuildContext context) {
    data.imageFile != null
        ? _photoBloc.photoInput.add(
            PhotoRequested(
              photo: data.imageFile!,
            ),
          )
        : null;
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
                      final PhotoState data = state.data!;
                      bool oldWasHandled = false;

                      if (data is PhotoFailureState && !data.wasHandled) {
                        handleError(data, context);
                        oldWasHandled = data.wasHandled;
                      }

                      if (data is PhotoSubmitedState && !data.wasHandled) {
                        handleSubmited(data, context);
                      }

                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            GestureDetector(
                              onTap: () => showImageSourceActionSheet(
                                context,
                                data.imageFile != null,
                                data.imageFile != null
                                    ? deletePhoto
                                    : updatePhoto,
                              ),
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CapybaColors.gray2.withOpacity(0.1),
                                    border: Border.all(
                                      color: (data is PhotoFailureState &&
                                              !oldWasHandled)
                                          ? CapybaColors.red
                                          : CapybaColors.capybaGreen,
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      if (data.imageFile != null)
                                        ClipOval(
                                          child: Image.file(
                                            data.imageFile!,
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
                                      if (data is PhotoLoadingState)
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
                              handleSubmit: () => handleRegister(data, context),
                              formKey: _formKey,
                              labelIsWidget: data is PhotoLoadingState,
                              labelWidget: CircularProgressIndicator(
                                color: CapybaColors.white,
                              ),
                              labelString: "Enviar",
                            ),
                            Visibility(
                              visible: widget.canBack,
                              child: Column(
                                children: [
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CapybaColors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: CapybaColors.capybaGreen,
                                            width: 0.5,
                                          )),
                                      minimumSize: const Size(180, 50),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Voltar",
                                      style: TextStyle(
                                        color: CapybaColors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
