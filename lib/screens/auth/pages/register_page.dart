import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase/screens/auth/widgets/auth_header.dart';
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

  @override
  Widget build(BuildContext context) {
    emailController.text = 'vitor@gmail.com';
    nameController.text = "awodmiawdmiaw";
    passwordController.text = "12345678";
    confirmPasswordController.text = "12345678";
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
                if (state.data is AuthFailureState && !state.data!.wasHandled) {
                  SnackBarNotification.error(
                    (state.data as AuthFailureState).exception,
                    context,
                  );
                  state.data!.wasHandled = true;
                }

                if (state.data is AuthSubmitedState &&
                    !state.data!.wasHandled) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBarNotification.success(
                      'Registro realizado com sucesso',
                      context,
                    );
                    Navigator.of(context).pushNamed(Routes.photoRegister);
                    state.data!.wasHandled = true;
                  });
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nome inválido';
                                }
                                return null;
                              },
                              obscureText: false,
                              labelText: 'Nome',
                              minLines: 1,
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
                            ),
                            const SizedBox(height: 24),
                            FormButton(
                              labelIsWidget: state.data is AuthLoadingState,
                              labelWidget: CircularProgressIndicator(
                                color: CapybaColors.white,
                              ),
                              labelString: "Registrar",
                              handleSubmit: () => _authBloc.authInput.add(
                                RegisterRequested(
                                  email: emailController.text,
                                  name: nameController.text,
                                  password: passwordController.text,
                                ),
                              ),
                              formKey: _formKey,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Já possui uma conta? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Faça login",
                              style: TextStyle(
                                fontSize: 14,
                                color: CapybaColors.capybaDarkGreen,
                              ),
                            ),
                          ),
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
