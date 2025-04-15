import 'package:flutter_firebase/screens/auth/pages/login_page.dart';
import 'package:flutter_firebase/screens/auth/pages/photo_register_page.dart';
import 'package:flutter_firebase/screens/auth/pages/register_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String login = '/';
  static String signup = '/signup';
  static String forgotMatricula = '/forgotMatricula';
  static String photoRegister = '/photoRegister';
  static String home = '/home';

  static final routes = [
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: signup,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: photoRegister,
      page: () =>  PhotoRegisterPage(),
    ),
  ];
}
