import 'package:flutter/material.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';
import 'package:flutter_firebase/screens/auth/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CapybaColors.capybaGreen,
        ),
        fontFamily: 'Montserrat',
      ),
      home: LoginPage(),
      getPages: Routes.routes,
    );
  }
}
