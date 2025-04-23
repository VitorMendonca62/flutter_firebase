import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/screens/galery_page.dart';
import 'package:flutter_firebase/screens/post/bloc/photo/photo_bloc.dart';
import 'package:flutter_firebase/screens/widgets/form_input.dart';
import 'package:flutter_firebase/screens/widgets/image_input.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController titleInputController = TextEditingController();
  final TextEditingController contentInputController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  late final PhotoBloc photoBloc;

  @override
  void initState() {
    photoBloc = PhotoBloc();
    super.initState();
  }

  Future<void> pickImage(
      ImageSource source, List<File> photos, BuildContext context) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        photoBloc.photoInput.add(
          AddPhoto(
            File(
              pickedFile.path,
            ),
            photos,
          ),
        );
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void showImageSourceActionSheet(
    List<File> photos,
    BuildContext parentContext,
  ) {
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
                  pickImage(ImageSource.gallery, photos, parentContext);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera, photos, parentContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  attachedImage(File source, BuildContext context) {
    return Image.file(
      source,
      width: MediaQuery.of(context).size.width * 0.3,
      height: 50,
      fit: BoxFit.fill,
    );
  }

  showImageModal(BuildContext context, int initialValue, List<File> photos) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: CapybaColors.black.withOpacity(0.1),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: CapybaColors.black.withOpacity(0.8),
            body: Center(
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: GalleryPage(
                      initialIndex: initialValue,
                      images: photos.map((file) {
                        final bytes = file.readAsBytesSync();
                        return MemoryImage(bytes);
                      }).toList(),
                    )),
              ),
            ),
          ),
        );
      },
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
            child: StreamBuilder<PhotoState>(
                stream: photoBloc.photoOutput,
                initialData: PhotoInitialState(),
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        "Criar novo post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: CapybaColors.gray1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormInput(
                        controller: titleInputController,
                        hintText: "Título do posts",
                        labelText: "Título",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Título inválido';
                          }
                          return null;
                        },
                        obscureText: false,
                        minLines: 1,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 12),
                      FormInput(
                        controller: contentInputController,
                        hintText: "O que você está pensando?",
                        labelText: "Conteúdo",
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Conteúdo inválido';
                          }
                          return null;
                        },
                        obscureText: false,
                        minLines: 5,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12),
                      ImageInput(
                        labelText: "Imagens anexadas",
                        handleOnTap: () => showImageSourceActionSheet(
                          state.data!.photos,
                          context,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.data!.photos.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            width: 16,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showImageModal(
                                  context,
                                  index,
                                  state.data!.photos,
                                );
                              },
                              child: attachedImage(
                                state.data!.photos[index],
                                context,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
