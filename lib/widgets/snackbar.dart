import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:get/get.dart';

class SnackBarNotification {
  static warning(String message, BuildContext context) {
    return Get.snackbar(
      'Aviso',
      message,
      colorText: CapybaColors.white,
      backgroundColor: CapybaColors.orange,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
    );
  }

  static success(String message, BuildContext context) {
    return Get.snackbar(
      'Sucesso',
      message,
      colorText: CapybaColors.white,
      backgroundColor: CapybaColors.capybaDarkGreen,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
    );
  }

  static error(String message, BuildContext context) {
    return Get.snackbar(
      'Erro',
      message,
      colorText: CapybaColors.white,
      backgroundColor: CapybaColors.red,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
    );
  }
}
