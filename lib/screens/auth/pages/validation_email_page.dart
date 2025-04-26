import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/blocs/validation_email/validation_email_bloc.dart';
import 'package:flutter_firebase/utils/orthers.dart';
import 'package:flutter_firebase/widgets/form_button.dart';
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

  handleSubmited(ValidationEmailState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.success(
        'Email enviado!',
        context,
      );
      goTo(Routes.home, context);
      data.wasHandled = true;
    });
  }

  handleEmailIsVerified(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.warning(
        "Seu e-mail já foi confirmado anteriormente. Você já pode usar todos os recursos do aplicativo normalmente.",
        context,
      );
      goTo(Routes.home, context);
    });
  }

  handleError(ValidationEmailState data, context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackBarNotification.error(
        (data as ValidationEmailFailureState).exception,
        context,
      );
      data.wasHandled = true;
    });
  }

  handleSubmit(ValidationEmailState data, BuildContext context) {
    validationEmailBloc.validationEmailInput.add(
      ValidationEmailRequestedEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      handleEmailIsVerified(context);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CapybaColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: StreamBuilder<ValidationEmailState>(
                stream: validationEmailBloc.validationEmailOutput,
                initialData: ValidationEmailInitialState(),
                builder: (context, state) {
                  final ValidationEmailState data = state.data!;

                  if (data is ValidationEmailFailureState && !data.wasHandled) {
                    handleError(data, context);
                  }

                  if (data is ValidationEmailSubmitedState &&
                      !data.wasHandled) {
                    handleSubmited(data, context);
                  }

                  return Form(
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
                        const SizedBox(height: 16),
                        FormButton(
                          handleSubmit:() => handleSubmit(data, context),
                          formKey: _formKey,
                          labelIsWidget: data is ValidationEmailLoadingState,
                          labelWidget: CircularProgressIndicator(
                            color: CapybaColors.white,
                          ),
                          labelString: "Registrar",
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
