// lib/features/auth/presentation/components/auth_header.dart
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.lock_outline, size: 64),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
