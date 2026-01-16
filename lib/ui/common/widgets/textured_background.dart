import 'package:flutter/material.dart';

/// Fond générique avec dégradé et texture (CustomPainter)
class TexturedBackground extends StatelessWidget {
  final Gradient gradient;
  final CustomPainter painter;

  const TexturedBackground({
    super.key,
    required this.gradient,
    required this.painter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: CustomPaint(
        painter: painter,
        child: const SizedBox.expand(),
      ),
    );
  }
}
