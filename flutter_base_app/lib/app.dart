import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<ThemeProvider>();
    final router = createRouter(context);

    return MaterialApp.router(
      title: 'Theming + Typography Control',
      themeMode: tp.mode,
      theme: AppTheme.light(fontScale: tp.fontScale, fontFamily: tp.fontFamily),
      darkTheme: AppTheme.dark(
        fontScale: tp.fontScale,
        fontFamily: tp.fontFamily,
      ),
      routerConfig: router,
    );
  }
}
