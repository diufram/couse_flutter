// lib/core/components/app_scaffold.dart
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? fab;
  const AppScaffold({super.key, this.appBar, required this.body, this.fab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: SafeArea(child: body),
      floatingActionButton: fab,
    );
  }
}
