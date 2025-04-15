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
