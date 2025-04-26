import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_email/update_email_bloc.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_password/update_password_bloc.dart';
import 'package:flutter_firebase/screens/profile/bloc/update_user/update_user_bloc.dart';
import 'package:flutter_firebase/screens/profile/widgets/update_email.dart';
import 'package:flutter_firebase/screens/profile/widgets/update_password.dart';
import 'package:flutter_firebase/screens/profile/widgets/update_user.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/app_bar.dart';
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
