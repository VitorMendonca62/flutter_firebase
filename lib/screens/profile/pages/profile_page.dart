import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_email/update_email_bloc.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_password/update_password_bloc.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_user/update_user_bloc.dart';
import 'package:flutter_firebase/screens/profile/widgets/update_email.dart';
import 'package:flutter_firebase/screens/profile/widgets/update_password.dart';
import 'package:flutter_firebase/screens/profile/widgets/update_user.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/app_bar.dart';
import 'package:flutter_firebase/widgets/tests_button.dart';
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
  final TextEditingController confirmNewPasswordInputController =
      TextEditingController();

  final ImagePicker picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  late final UpdateUserBloc updateUserBloc;
  late final UpdatePasswordBloc updatePasswordBloc;
  late final UpdateEmailBloc updateEmailBloc;

  @override
  void initState() {
    updateUserBloc = UpdateUserBloc();
    updatePasswordBloc = UpdatePasswordBloc();
    updateEmailBloc = UpdateEmailBloc();
    final User user = FirebaseAuth.instance.currentUser!;
    emailInputController.text = user.email!;
    nameInputController.text = user.displayName!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          constainsTitleLikeString: true,
          titleLikeString: "Perfil de usuário",
          canBack: true,
          onBack: () => goTo(
            Routes.home,
            context,
          ),
        ),
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                UpdateUser(
                  nameInputController: nameInputController,
                  formKey: _formKey,
                  updateUserBloc: updateUserBloc,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Divider(),
                ),
                UpdatePassword(
                  confirmNewPasswordInputController:
                      confirmNewPasswordInputController,
                  newPasswordInputController: newPasswordInputController,
                  formKey: _passwordFormKey,
                  updatePasswordBloc: updatePasswordBloc,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Divider(),
                ),
                UpdateEmail(
                  formKey: _emailFormKey,
                  emailInputController: emailInputController,
                  updateEmailBloc: updateEmailBloc,
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Área de teste',
                            style: TextStyle(
                                color: CapybaColors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Realize teste à vontade ou selecione um dos casos comuns abaixo.",
                      style: TextStyle(
                        fontSize: 16,
                        color: CapybaColors.gray2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 4.0,
                      children: [
                        TestsButton(
                          handleSubmit: () {
                            nameInputController.text = invalidName;
                          },
                          label: "Nome inválido",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            nameInputController.text = "";
                          },
                          label: "Nome vazio",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            nameInputController.text = "Vitor Mendoncaa";
                          },
                          label: "Nome válido",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            newPasswordInputController.text = invalidPassword;
                            confirmNewPasswordInputController.text =
                                invalidPassword;
                          },
                          label: "Senhas inválidas",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            newPasswordInputController.text = "";
                            confirmNewPasswordInputController.text = "";
                          },
                          label: "Senhas vazias",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            newPasswordInputController.text = validPassword;
                            confirmNewPasswordInputController.text = "123451";
                          },
                          label: "Senhas diferentes",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            newPasswordInputController.text = validPassword;
                            confirmNewPasswordInputController.text =
                                validPassword;
                          },
                          label: "Senhas válidas",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            emailInputController.text = invalidEmail;
                          },
                          label: "Email inválido",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            emailInputController.text = "";
                          },
                          label: "Email vazio",
                        ),
                        TestsButton(
                          handleSubmit: () {
                            emailInputController.text = validEmail;
                          },
                          label: "Email válido",
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
