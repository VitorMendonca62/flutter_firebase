import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PhotoRepository {
  final dio = Dio(BaseOptions(baseUrl: "https://api.imgur.com/3/"));
  final user = FirebaseAuth.instance.currentUser;

  Future<String> uploadPhotoInImgur(File image) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: basename(image.path),
      ),
      'type': 'image',
      'title': 'User photo ${user!.uid}',
      'description': 'This is a simple image upload in Imgur',
    });
    final response = await dio.post(
      'image',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Client-ID ${dotenv.env['CLIENT_ID']}',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data["data"]["link"];
    } else {
      throw Exception("Erro ao realizar o upload da foto");
    }
  }

  Future<void> updatePhoto(File image) async {
    try {
      String photoLink = await uploadPhotoInImgur(image);
      await user?.updatePhotoURL(photoLink);
    } on FirebaseAuthException catch (e) {
      throw Exception('Erro ao realizar o upload da foto: ${e.message}');
    }
  }
}
