import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_firebase/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/routes.dart';
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
  @override
  
  Widget build(BuildContext context) {
    requestPermissions();
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: CapybaColors.capybaGreen,
        ),
        fontFamily: 'Montserrat',
      ),
      routerConfig: router,
    );
  }
}
