// importações omitidas para brevidade

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase/screens/auth/widgets/auth_header.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
import 'package:flutter_firebase/widgets/form_input.dart';
import 'package:flutter_firebase/widgets/snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    emailController.text = "vitor@gmail.com";
    passwordController.text = "12345678";
    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: AuthHeader(
            title: "Bem vindo de volta!",
            subTitle: "Realize suas credenciais abaixo",
            child: StreamBuilder<AuthState>(
              stream: _authBloc.authOutput,
              initialData: AuthInitialState(),
              builder: (context, state) {
                if (state.data is AuthLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.data is AuthFailureState && !state.data!.wasHandled) {
                  SnackBarNotification.error(
                    (state.data as AuthFailureState).exception,
                    context,
                  );
                  state.data!.wasHandled = true;
                }

                if (state.data is AuthLoadedState && !state.data!.wasHandled) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBarNotification.success(
                      'Login realizado com sucesso',
                      context,
                    );
                    Navigator.of(context).pushNamed(Routes.home);
                    state.data!.wasHandled = true;
                  });
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
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
                              ),
                              const SizedBox(height: 12),
                              FormInput(
                                controller: passwordController,
                                hintText: '******',
                                keyboardType: TextInputType.text,
                                validator: passwordValidation,
                                obscureText: true,
                                labelText: 'Senha',
                                minLines: 1,
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Esqueceu sua senha?",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormButton(
                          label: "Entrar",
                          handleSubmit: () => _authBloc.authInput.add(
                            LoginRequested(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          ),
                          formKey: _formKey,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.signup,
                            );
                          },
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Ou entre com',
                                  style: TextStyle(color: Colors.grey),
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
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CapybaColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: CapybaColors.gray2,
                                width: 0.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            elevation: 0, // Remove box shadow
                          ),
                          onPressed: () {
                            _authBloc.authInput.add(
                              LoginWithGoogleRequested(),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return CapybaColors.greenGradient.createShader(bounds);
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Google",
                                style: TextStyle(
                                    color: CapybaColors.gray1, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
