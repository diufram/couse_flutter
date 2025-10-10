import 'package:flutter/material.dart';

class Breakpoints {
  static const mobile = 600.0;
  static const tablet = 1024.0;
  static const desktop = 1440.0;
}

extension ContextSizeX on BuildContext {
  double get w => MediaQuery.of(this).size.width;
  double get h => MediaQuery.of(this).size.height;

  bool get isMobile => w < Breakpoints.mobile;
  bool get isTablet => w >= Breakpoints.mobile && w < Breakpoints.tablet;
  bool get isDesktop => w >= Breakpoints.tablet;
}
