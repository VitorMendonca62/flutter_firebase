import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/post/blocs/create_post/create_post_bloc.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/utils/photo.dart';
import 'package:flutter_firebase/widgets/app_bar.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
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

  handleSubmit(CreatePostState data) {
    createPostBloc.createPostInput.add(
      CreatePostRequested(
        content: contentInputController.text,
        title: titleInputController.text,
        photos: data.photos,
        isRestrict: data.isRestrict,
      ),
    );
  }

  handleSubmited(CreatePostSubmitedState data, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Post criado com sucesso',
        context,
      );
      titleInputController.clear();
      contentInputController.clear();
    });
    data.wasHandled = true;
  }

  handleError(CreatePostFailureState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        data.exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  handleDelete(CreatePostState data, index) {
    createPostBloc.createPostInput.add(
      RemovePhoto(
        index: index,
        photos: data.photos,
        isRestrict: data.isRestrict,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          constainsTitleLikeString: true,
          titleLikeString: "Criar novo post",
          canBack: true,
          onBack: () => WidgetsBinding.instance.addPostFrameCallback((_) {
            pushRoute(
              PathRouter.home,
              context,
            );
          }),
        ),
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: StreamBuilder<CreatePostState>(
              stream: createPostBloc.createPostOutput,
              initialData: CreatePostInitialState(),
              builder: (context, state) {
                final CreatePostState data = state.data!;

                if (data is CreatePostSubmitedState && !data.wasHandled) {
                  handleSubmited(data, context);
                }

                if (data is CreatePostFailureState && !data.wasHandled) {
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
                      Visibility(
                        maintainState: false,
                        visible:
                            FirebaseAuth.instance.currentUser!.emailVerified,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
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
                                  value: data.isRestrict,
                                  trackColor: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return CapybaColors.capybaGreen;
                                      }
                                      return CapybaColors.white;
                                    },
                                  ),
                                  overlayColor: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(WidgetState.disabled)) {
                                        return CapybaColors.white;
                                      }
                                      return null;
                                    },
                                  ),
                                  onChanged: (bool value) {
                                    createPostBloc.createPostInput.add(
                                      ChangeSwitch(
                                        photos: data.photos,
                                        isRestrict: value,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ImageInput(
                        labelText: "Imagens anexadas",
                        handleOnTap: () => showImageSourceActionSheet(
                          context,
                          false,
                          (path) => createPostBloc.createPostInput.add(
                            AddPhoto(
                              photo: File(
                                path,
                              ),
                              photos: data.photos,
                              isRestrict: data.isRestrict,
                            ),
                          ),
                          true,
                        ),
                      ),
                      Visibility(
                        maintainState: false,
                        visible: data.photos.isNotEmpty,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.photos.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(
                                  width: 16,
                                ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showImageModal(
                                          context, index, data.photos, "file");
                                    },
                                    child: SizedBox(
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 100,
                                            child: attachedImage(
                                              data.photos[index],
                                              "file",
                                              context,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                            ),
                                          ),
                                          Positioned(
                                            right: 3,
                                            top: 3,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  handleDelete(data, index),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color:
                                                      CapybaColors.capybaGreen,
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: CapybaColors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                            labelIsWidget: data is CreatePostLoadingState,
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
