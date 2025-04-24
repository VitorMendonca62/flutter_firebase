import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/photo/photo_bloc.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';

class PhotoRegisterPage extends StatefulWidget {
  const PhotoRegisterPage({super.key});

  @override
  State<PhotoRegisterPage> createState() => _PhotoRegisterPageState();
}

class _PhotoRegisterPageState extends State<PhotoRegisterPage> {
  final ImagePicker picker = ImagePicker();

  late final PhotoBloc _photoBloc;

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        _photoBloc.photoInput.add(
          PhotoUpdate(
            File(pickedFile.path),
          ),
        );
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void _showImageSourceActionSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28.0)),
                ),
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, parentContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, parentContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _photoBloc = PhotoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: CapybaColors.gray1),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Foto do Perfil",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: CapybaColors.gray1,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Adicione uma foto para seu perfil",
                    style: TextStyle(
                      fontSize: 16,
                      color: CapybaColors.gray2,
                    ),
                  ),
                  Text(
                    "( Esse passo é obrigatório )",
                    style: TextStyle(
                      fontSize: 14,
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
                      return Column(
                        children: [
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: () => _showImageSourceActionSheet(context),
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
                              child: state.data is PhotoLoadingState
                                  ? const CircularProgressIndicator()
                                  : state.data?.imageFile != null
                                      ? ClipOval(
                                          child: Image.file(
                                            state.data!.imageFile!,
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: CapybaColors.capybaGreen,
                                        ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CapybaColors.capybaGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(180, 50),
                            ),
                            onPressed: state.data?.imageFile != null
                                ? () {
                                    _photoBloc.photoInput.add(
                                      PhotoRequested(
                                        state.data!.imageFile!,
                                      ),
                                    );
                                  }
                                : null,
                            child: Text(
                              "Continuar",
                              style: TextStyle(
                                color: CapybaColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
