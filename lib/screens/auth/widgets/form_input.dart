import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const FormInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 20),
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: CapybaColors.capybaGreen,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: CapybaColors.capybaGreen,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: CapybaColors.capybaDarkGreen,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: CapybaColors.red,
                width: 2.0,
              ),
            ),
            errorStyle: TextStyle(fontSize: 14, color: CapybaColors.red),
            contentPadding: const EdgeInsets.fromLTRB(23, 16, 23, 16),
            hintText: hintText,
            hintStyle: TextStyle(
              color: CapybaColors.gray200,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: CapybaColors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
