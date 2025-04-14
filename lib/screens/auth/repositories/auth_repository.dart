import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Login cancelado pelo usuário");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'Esta conta existe com um método de login diferente';
          break;
        case 'invalid-credential':
          message = 'Credencial inválida';
          break;
        case 'operation-not-allowed':
          message = 'Login com Google não está habilitado';
          break;
        case 'user-disabled':
          message = 'Conta desativada';
          break;
        default:
          message = 'Erro ao fazer login com Google: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro ao fazer login com Google: $e');
    }
  }

  Future<void> login(String email) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url:
            'https://desafio-capyba-f75d0.firebaseapp.com', // Domínio padrão do seu projeto
        handleCodeInApp: true,
        androidPackageName: 'com.capyba.challenge',
        androidInstallApp: true,
        androidMinimumVersion: '21',
        iOSBundleId: 'com.example.flutterFirebase',
      );

      await _auth.sendSignInLinkToEmail(
        email: email.trim(),
        actionCodeSettings: actionCodeSettings,
      );

      await saveEmailForSignIn(email);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-credential':
        case 'invalid-email':
          message = 'Email e/ou senha inválida';
          break;
        default:
          message = 'Erro ao fazer login: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  saveEmailForSignIn(String email) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString('email_for_sign_in', email);
  }

  saveUser(UserModel userModel) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', userModel.toJson().toString());
  }
}
