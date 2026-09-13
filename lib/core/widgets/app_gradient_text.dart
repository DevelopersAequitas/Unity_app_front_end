import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class AppGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const AppGradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = AppColor.brandGradient,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
  }
}
