import 'package:flutter/material.dart';
import 'package:flutter_base_app/features/auth/presentation/pages/home_page.dart';
import 'package:flutter_base_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_base_app/features/product/presentation/pages/products_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

class AuthListenable extends ChangeNotifier {
  AuthListenable(this._auth) {
    _auth.addListener(notifyListeners);
  }
  final AuthProvider _auth;
  bool get isLoggedIn => _auth.user != null;

  @override
  void dispose() {
    _auth.removeListener(notifyListeners);
    super.dispose();
  }
}

GoRouter createRouter(BuildContext context) {
  final auth = context.read<AuthProvider>();
  final authListenable = AuthListenable(auth);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authListenable,
    routes: [
      GoRoute(path: '/login', name: 'login', builder: (_, __) => LoginPage()),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (_, __) => const ProductsPage(),
      ),
    ],
    redirect: (ctx, state) {
      final loggedIn = authListenable.isLoggedIn;
      final loggingIn = state.matchedLocation == '/products';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/products';
      return null;
    },
  );
}
