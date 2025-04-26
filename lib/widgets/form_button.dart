import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class FormButton extends StatelessWidget {
  final void Function() handleSubmit;
  final GlobalKey<FormState> formKey;
  final bool labelIsWidget;
  final String? labelString;
  final Widget? labelWidget;

  const FormButton({
    super.key,
    required this.handleSubmit,
    required this.formKey,
    required this.labelIsWidget,
    this.labelString,
    this.labelWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CapybaColors.capybaGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(180, 50),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();

        if (!formKey.currentState!.validate()) {
          return;
        }
        handleSubmit();
      },
      child: labelIsWidget
          ? labelWidget
          : Text(
              labelString!,
              style: TextStyle(
                color: CapybaColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
