String? emailValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Digite um email';
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return 'Email inválido';
  }

  return null;
}

String? passwordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Digite uma senha';
  }

  if (value.length < 6) {
    return 'A senha deve ter no mínimo 6 caracteres';
  }

  return null;
}

String? nameValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Digite um nome';
  }

  final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  if (!nameRegex.hasMatch(value)) {
    return 'O nome deve conter apenas letras';
  }

  return null;
}

String? confirmPasswordValidation(String? password, String? confirmPassword) {
  final String? passwordValidationValue = passwordValidation(confirmPassword);
  if (passwordValidationValue != null) {
    return passwordValidationValue;
  }

  if (password != null && confirmPassword != password) {
    return 'As senhas devem ser iguais';
  }

  return null;
}

const String validEmail = "vitorqueiroz325@gmail.com";
const String validName = "Vitor Mendonca";
const String validPassword = "123456";

const String invalidEmail = "invalid.email.com";
const String invalidPassword = "12345";
const String invalidName = "Vitor@Mendonca";
