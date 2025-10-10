import 'package:flutter/material.dart';
import 'app_theme.dart';

extension ThemeX on BuildContext {
  // Tokens
  Spacing get sp => Theme.of(this).extension<Spacing>()!;
  Corners get cn => Theme.of(this).extension<Corners>()!;

  // Atajos tipográficos
  TextStyle get h1 => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get h2 => Theme.of(this).textTheme.headlineSmall!;
  TextStyle get h3 => Theme.of(this).textTheme.titleLarge!;
  TextStyle get title => Theme.of(this).textTheme.titleMedium!;
  TextStyle get body => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get label => Theme.of(this).textTheme.labelLarge!;
}
