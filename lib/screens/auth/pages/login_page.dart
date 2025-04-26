// importações omitidas para brevidade

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase/screens/auth/widgets/auth_header.dart';
import 'package:flutter_firebase/screens/auth/widgets/orther_providers.dart';
import 'package:flutter_firebase/screens/auth/widgets/tests_button.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late final AuthBloc _authBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _authBloc = AuthBloc();
    super.initState();
  }

  handleSubmited(AuthState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Login realizado com sucesso',
        context,
      );
      goTo(Routes.home, context);
      data.wasHandled = true;
    });
  }

  handleError(AuthState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        (data as AuthFailureState).exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  handleLogin() {
    _authBloc.authInput.add(
      LoginRequested(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  handleLoginWithGoogle() {
    _authBloc.authInput.add(
      LoginWithGoogleRequested(),
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
                title: "Bem vindo de volta!",
                subTitle: "Realize suas credenciais abaixo",
                child: StreamBuilder<AuthState>(
                  stream: _authBloc.authOutput,
                  initialData: AuthInitialState(),
                  builder: (context, state) {
                    final AuthState data = state.data!;
                    if (data is AuthFailureState && !data.wasHandled) {
                      handleError(data, context);
                    }

                    if (data is AuthSubmitedState && !data.wasHandled) {
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
                                  hintText: 'vitorqueiroz325@gmail.com',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: emailValidation,
                                  obscureText: false,
                                  labelText: 'Email',
                                  minLines: 1,
                                  maxLines: 1,
                                  isDisabled: false,
                                ),
                                const SizedBox(height: 16),
                                FormInput(
                                  controller: passwordController,
                                  hintText: '******',
                                  keyboardType: TextInputType.text,
                                  validator: passwordValidation,
                                  obscureText: true,
                                  labelText: 'Senha',
                                  minLines: 1,
                                  maxLines: 1,
                                  isDisabled: false,
                                ),
                                const SizedBox(height: 16),
                                FormButton(
                                  labelIsWidget: data is AuthLoadingState,
                                  labelString: "Entrar",
                                  labelWidget: CircularProgressIndicator(
                                    color: CapybaColors.white,
                                  ),
                                  handleSubmit: handleLogin,
                                  formKey: _formKey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => goTo(Routes.signup, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Não possui uma conta? "),
                                Text(
                                  "Cadastre-se",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CapybaColors.capybaDarkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          OrtherProviders(
                            handleGoogleLogin: handleLoginWithGoogle,
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
                                      emailController.text = validEmail;
                                      passwordController.text = invalidPassword;
                                    },
                                    label: "Senha curta",
                                  ),
                                  TestsButton(
                                    handleSubmit: () {
                                      emailController.text = invalidEmail;
                                      passwordController.text = invalidPassword;
                                    },
                                    label: "Ambos inválidos",
                                  ),
                                  TestsButton(
                                    handleSubmit: () {
                                      emailController.text = "";
                                      passwordController.text = "";
                                    },
                                    label: "Campos vazios",
                                  ),
                                  TestsButton(
                                    handleSubmit: () {
                                      emailController.text = validEmail;
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
