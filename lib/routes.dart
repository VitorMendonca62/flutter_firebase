import 'package:flutter_firebase/guards/auth_guard.dart';
import 'package:flutter_firebase/observebles/pop_screen_obeserveble.dart';
import 'package:flutter_firebase/screens/auth/pages/forgot_password_page.dart';
import 'package:flutter_firebase/screens/auth/pages/login_page.dart';
import 'package:flutter_firebase/screens/auth/pages/photo_register_page.dart';
import 'package:flutter_firebase/screens/auth/pages/register_page.dart';
import 'package:flutter_firebase/screens/auth/pages/validation_email_page.dart';
import 'package:flutter_firebase/screens/post/pages/create_post_page.dart';
import 'package:flutter_firebase/screens/post/pages/edit_post_page.dart';
import 'package:flutter_firebase/screens/posts/pages/subpages/home_page.dart';
import 'package:flutter_firebase/screens/posts/pages/subpages/restrict_page.dart';
import 'package:flutter_firebase/screens/profile/pages/profile_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PathRouter {
  static String login = '/login';
  static String signup = '/signup';
  static String forgotPassword = '/forgotPassword';
  static String photoRegister = '/photoRegister';
  static String home = '/home';
  static String restrict = '/restrict';
  static String createPost = '/createPost';
  static String editPost = '/editPost';
  static String profile = '/profile';
  static String validateEmail = '/validateEmail';
}

final GoRouter router = GoRouter(
  debugLogDiagnostics: true, // Ajuda a debugar navegação
  routerNeglect: true, // P
  observers: [
    // Add your navigator observers
    MyNavigatorObserver(),
  ],
  initialLocation: FirebaseAuth.instance.currentUser != null
      ? PathRouter.home
      : PathRouter.login,
  routes: <RouteBase>[
    GoRoute(
      path: PathRouter.login,
      redirect: noAuthGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: PathRouter.home,
      redirect: authGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: PathRouter.signup,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: PathRouter.forgotPassword,
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordPage();
      },
    ),
    GoRoute(
      path: PathRouter.photoRegister,
      redirect: photoGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const PhotoRegisterPage(canBack: true);
      },
    ),
    GoRoute(
      path: PathRouter.validateEmail,
      redirect: authGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const ValidateEmailPage();
      },
    ),
    GoRoute(
      path: PathRouter.restrict,
      redirect: authGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const RestrictPage();
      },
    ),
    GoRoute(
      path: PathRouter.createPost,
      redirect: authGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const CreatePostPage();
      },
    ),
    GoRoute(
      path: PathRouter.editPost,
      redirect: authGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const EditPostPage();
      },
    ),
    GoRoute(
      path: PathRouter.profile,
      redirect: authGuard,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),
  ],
);
