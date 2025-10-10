import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/storage/prefs_service.dart';
import 'core/di/di.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos SharedPreferences
  final sp = await SharedPreferences.getInstance();
  final prefs = PrefsService(sp);

  final di = AppDI.create(baseUrl: 'http://192.168.0.28:3000', prefs: prefs);

  runApp(MultiProvider(providers: di.providers(), child: const MyApp()));
}
