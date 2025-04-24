import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth/auth_bloc.dart';
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
    emailController.text = 'vitor@gmail.com';
    nameController.text = "awodmiawdmiaw";
    passwordController.text = "12345678";
    confirmPasswordController.text = "12345678";
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
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Criar conta",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: CapybaColors.gray1,
                          ),
                        ),
                        Text(
                          "Preencha seus dados abaixo",
                          style: TextStyle(
                            fontSize: 16,
                            color: CapybaColors.gray2,
                          ),
                        ),
                        StreamBuilder<AuthState>(
                          stream: _authBloc.authOutput,
                          initialData: AuthInitialState(),
                          builder: (context, state) {
                            if (state is AuthLoadingState) {
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
                                  'Registro realizado com sucesso',
                                  context,
                                );
                                Navigator.of(context)
                                    .pushNamed(Routes.photoRegister);
                                state.data!.wasHandled = true;
                              });
                            }

                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
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
                                    ElevatedButton(
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
                                        FocusScope.of(context).unfocus();

                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        _authBloc.authInput.add(
                                          RegisterRequested(
                                            email: emailController.text,
                                            name: nameController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Cadastrar",
                                        style: TextStyle(
                                          color: CapybaColors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              color:
                                                  CapybaColors.capybaDarkGreen,
                                            ),
                                          ),
                                        ),
                                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
