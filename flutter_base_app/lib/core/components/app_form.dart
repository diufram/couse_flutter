// lib/core/components/app_form.dart
import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  const AppForm({
    super.key,
    required this.child,
    this.maxWidth = 420,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    return Center(
      child: SingleChildScrollView(
        padding: (padding ?? const EdgeInsets.all(24)).add(
          EdgeInsets.only(bottom: insets > 0 ? 12 : 0),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
