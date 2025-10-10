// lib/core/components/app_card.dart
import 'package:flutter/material.dart';
import '../theme/theme_x.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const AppCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.cn.md);
    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: Padding(padding: EdgeInsets.all(context.sp.md), child: child),
      ),
    );
  }
}
