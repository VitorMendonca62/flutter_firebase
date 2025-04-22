import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class CommentsInput extends StatelessWidget {
  final TextEditingController controller;

  const CommentsInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      cursorColor: CapybaColors.black,
      style: const TextStyle(
        fontSize: 16,
      ),
      minLines: 2,
      maxLines: 2,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: CapybaColors.capybaGreen,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: CapybaColors.capybaGreen,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: CapybaColors.capybaDarkGreen,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: CapybaColors.red,
            width: 2.0,
          ),
        ),
        errorStyle: TextStyle(fontSize: 14, color: CapybaColors.red),
        contentPadding: const EdgeInsets.all(12),
        hintText: "Adicione um comentário...",
        hintStyle: TextStyle(
          color: CapybaColors.gray200,
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: CapybaColors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Digite uma comentário';
        }
        return null;
      },
    );
  }
}
