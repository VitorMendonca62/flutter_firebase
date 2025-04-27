import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class FormInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final bool isDisabled;

  const FormInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.keyboardType,
    required this.validator,
    required this.obscureText,
    required this.minLines,
    required this.maxLines,
    required this.isDisabled,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: CapybaColors.black,
          style: const TextStyle(fontSize: 20),
          obscureText: widget.obscureText && !_passwordVisible,
          enabled: !widget.isDisabled,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: CapybaColors.capybaGreen,
                width: 2.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
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
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: CapybaColors.gray200,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor:
                widget.isDisabled ? CapybaColors.gray300 : CapybaColors.white,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: CapybaColors.gray200,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
