import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/constants.dart';
import 'package:flutter_firebase/screens/auth/blocs/auth_bloc.dart';
import 'package:flutter_firebase/screens/auth/repositories/auth_repository.dart';
import 'package:flutter_firebase/screens/auth/widgets/form_input.dart';
import 'package:flutter_firebase/screens/widgets/snackbar.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  RegisterPage({super.key});

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

  validateForm() {
    if (!_formKey.currentState!.validate()) {
      SnackBarNotification.warning(
        _formKey.currentState!.validateGranularly().first.errorText!,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
                        BlocProvider(
                          create: (_) => AuthBloc(AuthRepository()),
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBarNotification.success(
                                    'Cadastro realizado com sucesso!',
                                  ),
                                );
                              } else if (state is AuthFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBarNotification.error(state.error),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
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
                                            return 'Por favor, insira seu nome';
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                        labelText: 'Nome',
                                      ),
                                      const SizedBox(height: 16),
                                      FormInput(
                                        controller: emailController,
                                        hintText: 'seu.email@exemplo.com',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: emailValidation,
                                        obscureText: false,
                                        labelText: 'Email',
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
                                          if (!validateForm()) return;

                                          BlocProvider.of<AuthBloc>(context)
                                              .add(
                                            RegisterRequested(
                                              emailController.text,
                                              nameController.text,
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
                                                color: CapybaColors
                                                    .capybaDarkGreen,
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
