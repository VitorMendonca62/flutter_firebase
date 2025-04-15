import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/user/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> loginWithGoogle() async {
    print('kkkKKKKKKKKKKKKKKKKKKKKK');
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
  }

  Future<void> login(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print('kkkKKKKKKKKKKKKKKKKKKKKK');
    throw Exception("EOOE");
    final actionCodeSettings = ActionCodeSettings(
      url: 'http://desafio-capyba-f75d0.firebaseapp.com',
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
  }

  Future<void> register(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://desafio-capyba-f75d0.firebaseapp.com',
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

    return await saveEmailForSignIn(email);
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
