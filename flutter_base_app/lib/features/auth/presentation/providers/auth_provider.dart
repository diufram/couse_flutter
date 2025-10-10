import 'dart:convert';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/storage/prefs_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final PrefsService _prefs;

  User? _user;
  bool _loading = false;
  String? _error;

  AuthProvider(this._loginUseCase, this._prefs) {
    _restoreSession();
  }

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> _restoreSession() async {
    try {
      final token = _prefs.token();
      final userStr = _prefs.userJson();
      if (token != null && userStr != null) {
        _user = User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
      }
    } catch (_) {
      // si algo falla, seguimos sin sesión
    } finally {
      notifyListeners(); // para refrescar el go_router redirect
    }
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // 1) Llamas al use case (que hace repo→remote)
      // Supón que tu backend devuelve token y user. Ajusta según tu API real.
      final user = await _loginUseCase(email, password);

      // 2) Simula/obtén el token (ajusta a tu respuesta real)
      final token = 'fake-token-${DateTime.now().millisecondsSinceEpoch}';

      // 3) Persiste token + user
      await _prefs.setToken(token);
      await _prefs.setUserJson(
        jsonEncode({'id': user.id, 'name': user.name, 'email': user.email}),
      );

      _user = user;
    } catch (e) {
      _error = 'No se pudo iniciar sesión';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    await _prefs.clearSession();
    notifyListeners();
  }
}
