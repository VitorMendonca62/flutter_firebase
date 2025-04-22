import 'package:flutter/material.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return RouteSettings(name: Routes.login);
    }

    return null;
  }
}

class NoAuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      return RouteSettings(name: Routes.home);
    }

    return null;
  }
}
