import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';

import 'package:flutter_firebase/screens/auth/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CapybaColors.capybaGreen,
        ),
        fontFamily: 'Montserrat',
      ),
      home: LoginPage(),
    );
  }
}
