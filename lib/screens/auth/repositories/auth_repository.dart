import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://sua-api.com"));

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'No user returned from Firebase',
        );
      }
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

  Future<void> register(String email, String password) async {
    final response = await _dio.post('/register', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode != 200) {
      throw Exception('Erro ao registrar');
    }
  }
}
