String? emailValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email está inválido';
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
