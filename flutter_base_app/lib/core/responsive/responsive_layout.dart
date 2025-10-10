import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Uso:
/// ResponsiveLayout(
///   mobile: (c) => ...,
///   tablet: (c) => ...,
///   desktop: (c) => ...,
/// )
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop && desktop != null) return desktop!(context);
    if (context.isTablet && tablet != null) return tablet!(context);
    return mobile(context);
  }
}
