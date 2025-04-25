import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/validation_email/validation_email_bloc.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
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
                    "Por favor, insira seu email para receber o link de validação",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: CapybaColors.gray2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormInput(
                    controller: emailInputController,
                    hintText: "exemplo@exemplo.com",
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidation,
                    obscureText: false,
                    minLines: 1,
                    maxLines: 1,
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
