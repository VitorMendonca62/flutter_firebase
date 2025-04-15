import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/models/user/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoRepository {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<void> updatePhoto(File image) async {
    try {
      // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Reference storageRef =
      //     firebaseStorage.ref().child('uploads/$fileName.jpg');

      // UploadTask uploadTask = storageRef.putFile(image);

      // await uploadTask;

    } on FirebaseAuthException catch (e) {
      throw Exception('Erro ao fazer login com Google: ${e.message}');
    }
  }
}
