import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase/screens/auth/widgets/auth_header.dart';
import 'package:flutter_firebase/widgets/tests_button.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  late final AuthBloc _authBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _authBloc = AuthBloc();
    super.initState();
  }

  handleSubmited(AuthState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Registro realizado com sucesso',
        context,
      );
      goTo(Routes.photoRegister, context);
      data.wasHandled = true;
    });
  }

  handleError(AuthState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        (data as AuthFailureState).exception,
        context,
      );

      goTo(Routes.login, context);

      data.wasHandled = true;
    });
  }

  handleRegister() {
    _authBloc.authInput.add(
      RegisterRequested(
        email: emailController.text,
        name: nameController.text,
        password: passwordController.text,
      ),
    );
  }

  handleLoginWithGoogle() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: AuthHeader(
            title: "Criar conta",
            subTitle: "Preencha seus dados abaixo",
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
                              controller: nameController,
                              hintText: 'Seu nome completo',
                              keyboardType: TextInputType.name,
                              validator: nameValidation,
                              labelText: 'Nome',
                              obscureText: false,
                              minLines: 1,
                              isDisabled: false,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 16),
                            FormInput(
                              controller: emailController,
                              hintText: 'seu.email@exemplo.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidation,
                              obscureText: false,
                              labelText: 'Email',
                              minLines: 1,
                              isDisabled: false,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 16),
                            FormInput(
                              controller: passwordController,
                              hintText: '********',
                              keyboardType: TextInputType.text,
                              validator: passwordValidation,
                              obscureText: true,
                              labelText: 'Senha',
                              minLines: 1,
                              maxLines: 1,
                              isDisabled: false,
                            ),
                            const SizedBox(height: 16),
                            FormInput(
                              controller: confirmPasswordController,
                              hintText: '********',
                              keyboardType: TextInputType.text,
                              validator: (String? value) =>
                                  confirmPasswordValidation(
                                passwordController.text,
                                value,
                              ),
                              obscureText: true,
                              labelText: 'Confirmação de senha',
                              minLines: 1,
                              maxLines: 1,
                              isDisabled: false,
                            ),
                            const SizedBox(height: 16),
                            FormButton(
                              labelIsWidget: data is AuthLoadingState,
                              labelWidget: CircularProgressIndicator(
                                color: CapybaColors.white,
                              ),
                              labelString: "Registrar",
                              handleSubmit: handleRegister,
                              formKey: _formKey,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                          goTo(Routes.signup, context);
                        }),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Já possui uma conta? "),
                            Text(
                              "Faça login",
                              style: TextStyle(
                                fontSize: 14,
                                color: CapybaColors.capybaDarkGreen,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  nameController.text = invalidName;
                                  emailController.text = validEmail;
                                  passwordController.text = validPassword;
                                  confirmPasswordController.text =
                                      validPassword;
                                },
                                label: "Nome inválido",
                              ),
                              TestsButton(
                                handleSubmit: () {
                                  nameController.text = validName;
                                  emailController.text = invalidEmail;
                                  passwordController.text = validPassword;
                                  confirmPasswordController.text =
                                      validPassword;
                                },
                                label: "Email inválido",
                              ),
                              TestsButton(
                                handleSubmit: () {
                                  nameController.text = validName;
                                  emailController.text = validEmail;
                                  passwordController.text = invalidPassword;
                                  confirmPasswordController.text =
                                      invalidPassword;
                                },
                                label: "Senha curta",
                              ),
                              TestsButton(
                                handleSubmit: () {
                                  nameController.text = validName;
                                  emailController.text = validEmail;
                                  passwordController.text = validPassword;
                                  confirmPasswordController.text =
                                      "12345678990";
                                },
                                label: "Senhas diferentes",
                              ),
                              TestsButton(
                                handleSubmit: () {
                                  nameController.text = invalidName;
                                  emailController.text = invalidEmail;
                                  passwordController.text = invalidPassword;
                                  confirmPasswordController.text =
                                      invalidPassword;
                                },
                                label: "Todos inválidos",
                              ),
                              TestsButton(
                                handleSubmit: () {
                                  nameController.text = "";
                                  emailController.text = "";
                                  passwordController.text = "";
                                  confirmPasswordController.text = "";
                                },
                                label: "Campos vazios",
                              ),
                              TestsButton(
                                handleSubmit: () {
                                  nameController.text = validName;
                                  emailController.text = validEmail;
                                  passwordController.text = validPassword;
                                  confirmPasswordController.text =
                                      validPassword;
                                },
                                label: "Usuário válido",
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
        ),
      ),
    );
  }
}
