// importações omitidas para brevidade

import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth/auth_bloc.dart';
import 'package:flutter_firebase/screens/auth/widgets/form_input.dart';
import 'package:flutter_firebase/screens/widgets/snackbar.dart';

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

  final LinearGradient greenGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF7DFA6F),
      Color(0xFF00C85E),
      Color(0xFF00E963),
    ],
    stops: [0.0, 0.5, 1.0],
  );

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
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: greenGradient,
                ),
                child: Image.asset(
                  "assets/images/logo_capyba.png",
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: greenGradient,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: CapybaColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Bem-vindo de volta!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: CapybaColors.gray1,
                          ),
                        ),
                        Text(
                          "Realize suas credenciais abaixo",
                          style: TextStyle(
                            fontSize: 16,
                            color: CapybaColors.gray2,
                          ),
                        ),
                        StreamBuilder<AuthState>(
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

                            if (state.data is AuthFailureState &&
                                !state.data!.wasHandled) {
                              SnackBarNotification.error(
                                (state.data as AuthFailureState).exception,
                                context,
                              );
                              state.data!.wasHandled = true;
                            }

                            if (state.data is AuthLoadedState &&
                                !state.data!.wasHandled) {
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
                                            hintText:
                                                'vitorqueiroz325@gmail.com',
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: emailValidation,
                                            obscureText: false,
                                            labelText: 'Email',
                                          ),
                                          const SizedBox(height: 12),
                                          FormInput(
                                            controller: passwordController,
                                            hintText: '******',
                                            keyboardType: TextInputType.text,
                                            validator: passwordValidation,
                                            obscureText: true,
                                            labelText: 'Senha',
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 10,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CapybaColors.capybaGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          minimumSize: const Size(180, 50),
                                        ),
                                        onPressed: () {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          _authBloc.authInput.add(
                                            LoginRequested(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Entrar",
                                          style: TextStyle(
                                            color: CapybaColors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text("Não possui uma conta? "),
                                          Text(
                                            "Cadastre-se",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  CapybaColors.capybaDarkGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              thickness: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Ou entre com',
                                              style:
                                                  TextStyle(color: Colors.grey),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                        mainAxisSize: MainAxisSize
                                            .min, // Adjust size to content
                                        children: [
                                          Icon(
                                            Icons.g_mobiledata,
                                            color: CapybaColors.gray1,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Google",
                                            style: TextStyle(
                                                color: CapybaColors.gray1,
                                                fontSize: 16),
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
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
