// importações omitidas para brevidade

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_firebase/screens/auth/widgets/auth_header.dart';
import 'package:flutter_firebase/widgets/tests_button.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  late final ForgotPasswordBloc _forgotPasswordBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _forgotPasswordBloc = ForgotPasswordBloc();
    super.initState();
  }

  handleSubmited(ForgotPasswordState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Email enviado com sucesso',
        context,
      );
      goTo(Routes.home, context);
      data.wasHandled = true;
    });
  }

  handleError(ForgotPasswordFailureState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        data.exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  handleForgotPassword() {
    _forgotPasswordBloc.forgotPasswordInput.add(
      ForgotPasswordRequestedEvent(
        email: emailController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AuthHeader(
                title: "Redefinir Senha",
                subTitle:
                    "Enviaremos um e-mail com um link para você. Para continuar, abra sua caixa de entrada, clique no link de redefinição, redefina a senha, volte ao app e realize o login. Caso não encontre, verifique também a pasta de spam ou lixo eletrônico.",
                child: StreamBuilder<ForgotPasswordState>(
                  stream: _forgotPasswordBloc.forgotPasswordOutput,
                  initialData: ForgotPasswordInitialState(),
                  builder: (context, state) {
                    final ForgotPasswordState data = state.data!;
                    if (data is ForgotPasswordFailureState &&
                        !data.wasHandled) {
                      handleError(data, context);
                    }

                    if (data is ForgotPasswordSubmitedState &&
                        !data.wasHandled) {
                      handleSubmited(data, context);
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                FormInput(
                                  controller: emailController,
                                  hintText: validEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: emailValidation,
                                  obscureText: false,
                                  labelText: 'Email',
                                  minLines: 1,
                                  maxLines: 1,
                                  isDisabled: false,
                                ),
                                const SizedBox(height: 16),
                                FormButton(
                                  labelIsWidget:
                                      data is ForgotPasswordLoadingState,
                                  labelString: "Enviar",
                                  labelWidget: CircularProgressIndicator(
                                    color: CapybaColors.white,
                                  ),
                                  handleSubmit: handleForgotPassword,
                                  formKey: _formKey,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CapybaColors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: CapybaColors.capybaGreen,
                                          width: 0.5,
                                        )),
                                    minimumSize: const Size(180, 50),
                                  ),
                                  onPressed: () {
                                    goTo(Routes.login, context);
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
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
                                      emailController.text = invalidEmail;
                                      passwordController.text = validPassword;
                                    },
                                    label: "Email inválido",
                                  ),
                                  TestsButton(
                                    handleSubmit: () {
                                      emailController.text =
                                          "vitormsi2005@gmail.com";
                                      passwordController.text = validPassword;
                                    },
                                    label: "Usuário existente",
                                  ),
                                  TestsButton(
                                    handleSubmit: () {
                                      emailController.text = "vitor@gmail.com";
                                      passwordController.text = validPassword;
                                    },
                                    label: "Usuário inexistente",
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
