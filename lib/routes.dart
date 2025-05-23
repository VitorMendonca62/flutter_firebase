import 'package:flutter_firebase/guards/auth_guard.dart';
import 'package:flutter_firebase/guards/photo_guard.dart';
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
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String login = '/';
  static String signup = '/signup';
  static String forgotPassword = '/forgotPassword';
  static String photoRegister = '/photoRegister';
  static String home = '/home';
  static String restrict = '/restrict';
  static String createPost = '/createPost';
  static String editPost = '/editPost';
  static String profile = '/profile';
  static String validateEmail = '/validateEmail';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: signup,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordPage(),
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
      page: () => const HomePage(),
      middlewares: [
        AuthGuard(),
        PhotoGuard(),
      ],
    ),
    GetPage(
      name: restrict,
      page: () => const RestrictPage(),
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
    GetPage(
      name: editPost,
      page: () => const EditPostPage(),
      middlewares: [
        AuthGuard(),
        PhotoGuard(),
      ],
    ),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
      middlewares: [
        AuthGuard(),
        PhotoGuard(),
      ],
    ),
  ];
}
