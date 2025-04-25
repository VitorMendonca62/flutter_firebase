import 'package:flutter_firebase/guards/auth_guard.dart';
import 'package:flutter_firebase/guards/photo_guard.dart';
import 'package:flutter_firebase/screens/auth/pages/login_page.dart';
import 'package:flutter_firebase/screens/auth/pages/photo_register_page.dart';
import 'package:flutter_firebase/screens/auth/pages/register_page.dart';
import 'package:flutter_firebase/screens/auth/pages/validate_email_page.dart';
import 'package:flutter_firebase/screens/posts/pages/container_page.dart';
import 'package:flutter_firebase/screens/post/pages/create_post_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String login = '/';
  static String signup = '/signup';
  static String photoRegister = '/photoRegister';
  static String home = '/home';
  static String createPost = '/createPost';
  static String profile = '/profile';
  static String validateEmail = '/validateEmail';

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
      page: () => const PhotoRegisterPage(
        canBack: true,
      ),
      middlewares: [
        AuthGuard(),
      ],
    ),
    GetPage(
      name: validateEmail,
      page: () => const ValidateEmailPage(),
      middlewares: [
        AuthGuard(),
      ],
    ),
    GetPage(
      name: home,
      page: () => const ContainerPage(),
      middlewares: [
        AuthGuard(),
        PhotoGuard(),
      ],
    ),
    GetPage(
      name: createPost,
      page: () => const CreatePostPage(),
      middlewares: [
        AuthGuard(),
        PhotoGuard(),
      ],
    ),
  ];
}
