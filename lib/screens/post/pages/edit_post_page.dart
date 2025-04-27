import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/models/post/post_model.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/post/blocs/edit_post/edit_post_bloc.dart';
import 'package:flutter_firebase/screens/post/widgets/post_images.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/utils/photo.dart';
import 'package:flutter_firebase/widgets/app_bar.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/image_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({super.key});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController titleInputController = TextEditingController();
  final TextEditingController contentInputController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  late final EditPostBloc editPostBloc;

  final _arguments = Get.arguments;
  late final PostModel post;
  late final bool isRestrict;

  @override
  void initState() {
    editPostBloc = EditPostBloc();
    post = _arguments["post"];
    isRestrict = _arguments["isRestrict"];
    titleInputController.text = post.title;
    contentInputController.text = post.content;
    super.initState();
  }

  handleSubmit(EditPostState data) {
    editPostBloc.editPostInput.add(
      EditPostRequested(
        postId: post.id!,
        content: contentInputController.text != post.content
            ? contentInputController.text
            : null,
        title: titleInputController.text != post.title
            ? titleInputController.text
            : null,
        photos: data.photos,
        newPhotos: data.newPhotos,
        isRestrict: data.isRestrict,
      ),
    );
  }

  handleSubmited(EditPostSubmitedState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Post editado com sucesso',
        context,
      );
    });
    data.wasHandled = true;
  }

  handleError(EditPostFailureState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        data.exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  handleDelete(
    EditPostState data,
    int index,
    bool newPhoto,
  ) {
    editPostBloc.editPostInput.add(
      RemovePhoto(
        index: index,
        photos: data.photos,
        newPhotos: data.newPhotos,
        isRestrict: data.isRestrict,
        isNewPhoto: newPhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          constainsTitleLikeString: true,
          titleLikeString: "Editar post",
          canBack: true,
          onBack: () => WidgetsBinding.instance.addPostFrameCallback((_) {
            goTo(
              Routes.home,
              context,
            );
          }),
        ),
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: StreamBuilder<EditPostState>(
              stream: editPostBloc.editPostOutput,
              initialData: EditPostInitialState(photos: post.photos),
              builder: (context, state) {
                final EditPostState data = state.data!;

                if (data is EditPostSubmitedState && !data.wasHandled) {
                  handleSubmited(data, context);
                }

                if (data is EditPostFailureState && !data.wasHandled) {
                  handleError(data, context);
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        isDisabled: false,
                      ),
                      const SizedBox(height: 16),
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
                        isDisabled: false,
                      ),
                      const SizedBox(height: 16),
                      ImageInput(
                        labelText: "Imagens anexadas",
                        handleOnTap: () => showImageSourceActionSheet(
                          context,
                          false,
                          (path) => editPostBloc.editPostInput.add(
                            AddPhoto(
                              photo: File(
                                path,
                              ),
                              photos: data.photos,
                              newPhotos: data.newPhotos,
                              isRestrict: data.isRestrict,
                            ),
                          ),
                          true,
                        ),
                      ),
                      if (data.photos.isNotEmpty || data.newPhotos != null)
                        PostImages(
                          data: data,
                          handleDelete: handleDelete,
                          oldPhotos: data.photos,
                          newPhotos: data.newPhotos,
                        ),
                      const SizedBox(height: 16),
                      Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            bottom: 10,
                          ),
                          child: FormButton(
                            handleSubmit: () => handleSubmit(data),
                            formKey: _formKey,
                            labelIsWidget: data is EditPostLoadingState,
                            labelString: "Criar",
                            labelWidget: CircularProgressIndicator(
                              color: CapybaColors.white,
                            ),
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
