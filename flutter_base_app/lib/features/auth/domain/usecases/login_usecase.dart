import 'package:flutter_base_app/features/auth/domain/repositories/auth_provider.dart';

import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User> call(String email, String password) =>
      repository.login(email, password);
}
