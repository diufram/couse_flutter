import 'package:flutter_base_app/features/auth/domain/repositories/auth_provider.dart';

import '../../domain/entities/user.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String email, String password) {
    return remote.login(email, password);
  }
}
