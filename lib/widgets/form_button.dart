import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class FormButton extends StatelessWidget {
  final void Function() handleSubmit;
  final GlobalKey<FormState> formKey;
  final String label;

  const FormButton({
    super.key,
    required this.handleSubmit,
    required this.formKey,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 10,
      ),
      child: ElevatedButton(
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
        child: Text(
          label,
          style: TextStyle(
            color: CapybaColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
