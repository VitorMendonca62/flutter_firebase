import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/galery_page.dart';
import 'package:flutter_firebase/screens/post/bloc/create_post/create_post_bloc.dart';
import 'package:flutter_firebase/utils/photo.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/image_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
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

  final _formKey = GlobalKey<FormState>();

  late final CreatePostBloc createPostBloc;

  @override
  void initState() {
    createPostBloc = CreatePostBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: StreamBuilder<CreatePostState>(
                stream: createPostBloc.createPostOutput,
                initialData: CreatePostInitialState(),
                builder: (context, state) {
                  if (state.data is CreatePostSubmitedState &&
                      !state.data!.wasHandled) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      SnackBarNotification.success(
                        'Post criado com sucesso',
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "É restrito?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Switch(
                              value: state.data!.isRestrict,
                              trackColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return CapybaColors.capybaGreen;
                                  }
                                  return CapybaColors.white;
                                },
                              ),
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return CapybaColors.white;
                                  }
                                  return null;
                                },
                              ),
                              onChanged: (bool value) {
                                createPostBloc.createPostInput.add(
                                  ChangeSwitch(
                                    photos: state.data!.photos,
                                    isRestrict: value,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ImageInput(
                          labelText: "Imagens anexadas",
                          handleOnTap: () => showImageSourceActionSheet(
                            context,
                            (path) => createPostBloc.createPostInput.add(
                              AddPhoto(
                                photo: File(
                                  path,
                                ),
                                photos: state.data!.photos,
                                isRestrict: state.data!.isRestrict,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Visibility(
                          visible: state.data!.photos.isNotEmpty,
                          child: SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.data!.photos.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
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
                                      "file"
                                    );
                                  },
                                  child: attachedImage(
                                    state.data!.photos[index],
                                    "file",
                                    context,
                                    MediaQuery.of(context).size.width * 0.3,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            bottom: 10,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CapybaColors.capybaGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(180, 50),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              createPostBloc.createPostInput.add(
                                CreatePostRequested(
                                  content: contentInputController.text,
                                  title: titleInputController.text,
                                  photos: state.data!.photos,
                                  isRestrict: state.data!.isRestrict,
                                ),
                              );
                              _formKey.currentState!.reset();
                            },
                            child: Text(
                              "Criar",
                              style: TextStyle(
                                color: CapybaColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
