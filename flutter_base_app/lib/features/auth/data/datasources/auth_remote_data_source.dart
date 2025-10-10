import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSource(this.dio);

  /// Ajusta esta llamada al formato real de tu API
  Future<User> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Si tu API devuelve { "user": { ... } }, ajusta a response.data['user']
      final data = response.data;
      final userJson = (data is Map && data['user'] is Map)
          ? Map<String, dynamic>.from(data['user'] as Map)
          : Map<String, dynamic>.from(data as Map);
      return User.fromJson(userJson);
    } else {
      throw Exception('Error ${response.statusCode} al iniciar sesión');
    }
  }
}
