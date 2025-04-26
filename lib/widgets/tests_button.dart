import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

class TestsButton extends StatelessWidget {
  final void Function() handleSubmit;
  final String label;

  const TestsButton({
    super.key,
    required this.handleSubmit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CapybaColors.capybaGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fixedSize:  const Size(150, 35),
      ),
      onPressed: () {
        handleSubmit();
      },
      child: Text(
        label,
        style: TextStyle(
          color: CapybaColors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
