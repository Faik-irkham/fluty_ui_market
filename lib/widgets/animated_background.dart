import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// CustomPainter untuk partikel animasi mengambang di background.
class ParticlePainter extends CustomPainter {
  final double animationValue;
  final List<Offset> particles;
  final List<double> sizes;

  const ParticlePainter(this.animationValue, this.particles, this.sizes);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final double t = (animationValue + i * 0.1) % 1.0;
      final double opacity = (sin(t * pi * 2) * 0.5 + 0.5) * 0.35;
      final paint = Paint()
        ..color = AppColors.purple.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final dx = particles[i].dx * size.width;
      final dy = (particles[i].dy + t * 0.1) % 1.0 * size.height;

      canvas.drawCircle(Offset(dx, dy), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

/// Widget background animasi — gradient yang bergeser warna secara halus.
class AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, _) {
        final t = animation.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                    const Color(0xFF0A0A14), const Color(0xFF0D0A20), t)!,
                Color.lerp(
                    const Color(0xFF0F0F24), const Color(0xFF140A20), t)!,
                Color.lerp(
                    const Color(0xFF0A0A14), const Color(0xFF0A0D18), t)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}
