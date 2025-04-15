import 'package:flutter_firebase/guards/auth_guard.dart';
import 'package:flutter_firebase/screens/auth/pages/login_page.dart';
import 'package:flutter_firebase/screens/auth/pages/photo_register_page.dart';
import 'package:flutter_firebase/screens/auth/pages/register_page.dart';
import 'package:flutter_firebase/screens/home/pages/container_page.dart';
import 'package:flutter_firebase/screens/home/pages/home_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String login = '/';
  static String signup = '/signup';
  static String photoRegister = '/photoRegister';
  static String home = '/home';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
      middlewares: [
        NoAuthGuard(),
      ],
    ),
    GetPage(
      name: signup,
      page: () => const RegisterPage(),
      middlewares: [
        NoAuthGuard(),
      ],
    ),
    GetPage(
      name: photoRegister,
      page: () => const PhotoRegisterPage(),
      middlewares: [
        AuthGuard(),
      ],
    ),
    GetPage(
      name: home,
      page: () => const ContainerPage(),
      middlewares: [
        AuthGuard(),
      ],
    ),
  ];
}
