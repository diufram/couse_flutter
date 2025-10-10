import 'package:flutter/material.dart';

/// Tokens de diseño (espacios y radios) como ThemeExtension
class Spacing extends ThemeExtension<Spacing> {
  final double xxs, xs, sm, md, lg, xl;
  const Spacing({
    this.xxs = 4,
    this.xs = 8,
    this.sm = 12,
    this.md = 16,
    this.lg = 20,
    this.xl = 24,
  });
  @override
  Spacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) => Spacing(
    xxs: xxs ?? this.xxs,
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
  );
  @override
  ThemeExtension<Spacing> lerp(ThemeExtension<Spacing>? other, double t) =>
      this;
}

class Corners extends ThemeExtension<Corners> {
  final double sm, md, lg;
  const Corners({this.sm = 8, this.md = 12, this.lg = 16});
  @override
  Corners copyWith({double? sm, double? md, double? lg}) =>
      Corners(sm: sm ?? this.sm, md: md ?? this.md, lg: lg ?? this.lg);
  @override
  ThemeExtension<Corners> lerp(ThemeExtension<Corners>? other, double t) =>
      this;
}

class AppTheme {
  static const _seed = Color(0xFF2563EB);

  /// Construye un ThemeData con control de:
  /// - brightness (light/dark)
  /// - fontScale (ej. 0.9, 1.0, 1.1)
  /// - fontFamily (opcional)
  static ThemeData themed({
    required Brightness brightness,
    double fontScale = 1.0,
    String? fontFamily,
  }) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      useMaterial3: true,
    );

    final baseText = brightness == Brightness.light
        ? Typography.material2021(platform: base.platform).black
        : Typography.material2021(platform: base.platform).white;

    final textTheme = _scaledTextTheme(baseText, fontScale, fontFamily);

    return base.copyWith(
      textTheme: textTheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
      extensions: const [Spacing(), Corners()],
    );
  }

  static ThemeData light({double fontScale = 1.0, String? fontFamily}) =>
      themed(
        brightness: Brightness.light,
        fontScale: fontScale,
        fontFamily: fontFamily,
      );

  static ThemeData dark({double fontScale = 1.0, String? fontFamily}) => themed(
    brightness: Brightness.dark,
    fontScale: fontScale,
    fontFamily: fontFamily,
  );

  /// Aplica fontScale y (opcional) fontFamily a todo el TextTheme
  static TextTheme _scaledTextTheme(
    TextTheme src,
    double scale,
    String? family,
  ) {
    TextStyle? s(TextStyle? x, double size, [FontWeight? w]) =>
        (x ?? const TextStyle()).copyWith(
          fontSize: size * scale,
          fontWeight: w ?? x?.fontWeight,
          fontFamily: family ?? x?.fontFamily,
        );

    return src.copyWith(
      // Títulos
      headlineLarge: s(src.headlineLarge, 28, FontWeight.w700),
      headlineMedium: s(
        src.headlineMedium ?? src.headlineSmall,
        24,
        FontWeight.w600,
      ),
      headlineSmall: s(src.headlineSmall, 22, FontWeight.w600),
      // Subtítulos / títulos de sección
      titleLarge: s(src.titleLarge, 20, FontWeight.w600),
      titleMedium: s(src.titleMedium, 16, FontWeight.w600),
      titleSmall: s(src.titleSmall, 14, FontWeight.w600),
      // Cuerpo
      bodyLarge: s(src.bodyLarge, 16),
      bodyMedium: s(src.bodyMedium, 14),
      bodySmall: s(src.bodySmall, 12),
      // Etiquetas / botones
      labelLarge: s(src.labelLarge, 13, FontWeight.w600),
      labelMedium: s(src.labelMedium, 12, FontWeight.w600),
      labelSmall: s(src.labelSmall, 11, FontWeight.w600),
    );
  }
}
