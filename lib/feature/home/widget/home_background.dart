import 'dart:math';

import 'package:flutter/material.dart';

/// Ana sayfa animasyonlu arka plan — yüzen QR kod desenleri efekti.
class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key});

  static final enabledNotifier = ValueNotifier<bool>(true);

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_FloatingQr> _qrList;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    );

    final enabled = HomeBackground.enabledNotifier.value;
    if (enabled) _controller.repeat(reverse: true);

    HomeBackground.enabledNotifier.addListener(_onToggle);

    final rng = Random(42);
    _qrList = List.generate(8, (i) {
      return _FloatingQr(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: 30.0 + rng.nextDouble() * 30,
        speed: 0.3 + rng.nextDouble() * 0.7,
        opacity: 0.06 + rng.nextDouble() * 0.07,
        gridSize: 3 + rng.nextInt(3), // 3x3, 4x4 veya 5x5
        seed: rng.nextInt(1000),
      );
    });
  }

  void _onToggle() {
    if (HomeBackground.enabledNotifier.value) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
    setState(() {});
  }

  @override
  void dispose() {
    HomeBackground.enabledNotifier.removeListener(_onToggle);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!HomeBackground.enabledNotifier.value) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: size,
          painter: _BackgroundPainter(
            progress: _controller.value,
            qrList: _qrList,
            color: cs.primary,
          ),
        );
      },
    );
  }
}

class _FloatingQr {
  const _FloatingQr({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.gridSize,
    required this.seed,
  });
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final int gridSize;
  final int seed;
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    required this.progress,
    required this.qrList,
    required this.color,
  });
  final double progress;
  final List<_FloatingQr> qrList;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final qr in qrList) {
      final yOffset = (qr.y + progress * qr.speed) % 1.3 - 0.15;
      final cx = qr.x * size.width;
      final cy = yOffset * size.height;
      final s = qr.size;
      final c = color.withValues(alpha: qr.opacity);

      // QR kare çerçeve
      final strokePaint = Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final rect = Rect.fromCenter(center: Offset(cx, cy), width: s, height: s);
      canvas.drawRect(rect, strokePaint);

      // QR grid deseni
      final fillPaint = Paint()
        ..color = c
        ..style = PaintingStyle.fill;

      final cellSize = s / qr.gridSize;
      final rng = Random(qr.seed);

      for (var row = 0; row < qr.gridSize; row++) {
        for (var col = 0; col < qr.gridSize; col++) {
          if (rng.nextBool()) {
            final cellRect = Rect.fromLTWH(
              rect.left + col * cellSize,
              rect.top + row * cellSize,
              cellSize * 0.85,
              cellSize * 0.85,
            );
            canvas.drawRect(cellRect, fillPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
