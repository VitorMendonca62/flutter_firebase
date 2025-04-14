import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://sua-api.com"));

  Future<void> login(String email, String password) async {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode != 200) {
      throw Exception('Erro ao logar');
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
