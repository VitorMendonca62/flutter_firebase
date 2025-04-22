import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class PhotoGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.photoURL == null) {
      return RouteSettings(name: Routes.photoRegister);
    } 

    return null;
  }
}