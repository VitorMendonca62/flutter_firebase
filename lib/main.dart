import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:flutter_firebase/screens/auth/pages/login_page.dart';
import 'package:flutter_firebase/screens/auth/pages/photo_register_page.dart';
import 'package:flutter_firebase/screens/posts/pages/subpages/home_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  initialPage() {
    if (FirebaseAuth.instance.currentUser == null) {
      return const LoginPage();
    }

    if (FirebaseAuth.instance.currentUser!.photoURL == null) {
      return const PhotoRegisterPage(canBack: false,);
    }

    return const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    requestPermissions();
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CapybaColors.capybaGreen,
        ),
        fontFamily: 'Montserrat',
      ),
      home: initialPage(),
      getPages: Routes.routes,
    );
  }
}
