import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/routes.dart';
import 'package:go_router/go_router.dart';

String? authGuard(BuildContext context, GoRouterState state) {
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  if (!isLoggedIn) return PathRouter.login;

  return null;
}

String? noAuthGuard(BuildContext context, GoRouterState state) {
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  if (isLoggedIn) return PathRouter.home;

  return null;
}

String? photoGuard(BuildContext context, GoRouterState state) {
  final user = FirebaseAuth.instance.currentUser;
  final hasPhoto = user?.photoURL != null && user!.photoURL!.isNotEmpty;

  if (!hasPhoto && state.path != '/photo-register') {
    return PathRouter.photoRegister;
  }

  return null;
}
