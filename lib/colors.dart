import 'package:flutter/material.dart';

class CapybaColors {
  static Color red = const Color(0xFFE53935);
  static Color capybaGreen = const Color(0xff00e963);
  static Color capybaDarkGreen = const Color(0xff08a84c);
  static Color capybaMoreDarkGreen = const Color(0xFF067E3A);
  static Color gray1 = const Color(0xFF141414);
  static Color gray2 = const Color(0xFF474747);
  static Color gray200 = const Color(0x60000000);
  static Color gray300 = const Color.fromARGB(255, 225, 225, 225);
  static Color white = const Color(0xFFFFFFFF);
  static Color orange = const Color(0xFFED9948);
  static Color black = const Color(0xFF000000);
  static LinearGradient greenGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF7DFA6F),
      Color(0xFF00C85E),
      Color(0xFF00E963),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  static LinearGradient greenInvertGradient = const LinearGradient(
    end: Alignment.centerLeft,
    begin: Alignment.centerRight,
    colors: [
      Color(0xFF7DFA6F),
      Color(0xFF00C85E),
      Color(0xFF00E963),
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
