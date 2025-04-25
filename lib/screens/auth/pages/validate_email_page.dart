import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/validation_email/validation_email_bloc.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class ValidateEmailPage extends StatefulWidget {
  const ValidateEmailPage({super.key});

  @override
  State<ValidateEmailPage> createState() => _ValidateEmailPageState();
}

class _ValidateEmailPageState extends State<ValidateEmailPage> {
  final TextEditingController emailInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final ValidationEmailBloc validationEmailBloc;

  @override
  void initState() {
    validationEmailBloc = ValidationEmailBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarNotification.warning(
          "Seu e-mail já foi confirmado anteriormente. Você já pode usar todos os recursos do aplicativo normalmente.",
          context,
        );
        Navigator.of(context).pushNamed(Routes.home);
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Validar email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: CapybaColors.gray1,
                    ),
                  ),
                  Text(
                    "Enviaremos um e-mail com um link de verificação para você. Para continuar, abra sua caixa de entrada, clique no link de confirmação e volte ao app. Assim que confirmar, seu acesso será liberado automaticamente.Caso não encontre, verifique também a pasta de spam ou lixo eletrônico.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: CapybaColors.gray2,
                    ),
                  ),
                  const SizedBox(height: 12),
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

                        validationEmailBloc.validationEmailInput.add(
                          ValidationEmailRequestedEvent(),
                        );
                        SnackBarNotification.success(
                          'Email enviado!',
                          context,
                        );
                        Navigator.of(context).pushNamed(Routes.home);
                      },
                      child: Text(
                        "Validar",
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
            ),
          ),
        ),
      ),
    );
  }
}
