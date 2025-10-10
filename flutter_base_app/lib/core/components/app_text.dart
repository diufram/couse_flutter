import 'package:flutter/material.dart';
import '../theme/theme_x.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;

  const AppText(this.text, {super.key, this.style, this.align, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? context.body,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
    );
  }
}

class AppTitle extends StatelessWidget {
  final String text;
  final int level; // 1=h1, 2=h2, 3=h3
  final TextAlign? align;

  const AppTitle(this.text, {super.key, this.level = 2, this.align});

  @override
  Widget build(BuildContext context) {
    final style = switch (level) {
      1 => context.h1,
      2 => context.h2,
      _ => context.h3,
    };
    return Text(text, style: style, textAlign: align);
  }
}
