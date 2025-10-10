import 'package:flutter/material.dart';
import 'package:flutter_base_app/features/product/presentation/widgets/product_list_view.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/components/app_scaffold.dart';
import '../../../../core/components/app_card.dart';
import '../../../../core/components/app_text.dart';
import '../../../../core/theme/theme_x.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final width = MediaQuery.of(context).size.width;
    final cols = width < 600 ? 2 : (width < 1024 ? 3 : 4);
    final ratio = width < 600 ? 1.0 : 4 / 3;

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          // Switch tema claro/oscuro
          IconButton(
            tooltip: 'Claro / Oscuro',
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeProvider>().toggleMode(),
          ),
          // Control de tamaño tipográfico
          PopupMenuButton<double>(
            tooltip: 'Tamaño de fuente',
            onSelected: (v) => context.read<ThemeProvider>().setFontScale(v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 0.9, child: Text('Pequeña (0.9x)')),
              PopupMenuItem(value: 1.0, child: Text('Normal (1.0x)')),
              PopupMenuItem(value: 1.1, child: Text('Grande (1.1x)')),
            ],
            icon: const Icon(Icons.text_increase),
          ),
          // Logout
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(context.sp.md),
        child: ProductListView(),
      ),
    );
  }
}
