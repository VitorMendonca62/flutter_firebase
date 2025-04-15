import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class PhotoRepository {
  Future<void> updatePhoto(File image) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      await user?.updatePhotoURL(image.path);

    } on FirebaseAuthException catch (e) {
      throw Exception('Erro ao fazer enviar foto: ${e.message}');
    }
  }
}
