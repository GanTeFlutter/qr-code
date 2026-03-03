import 'package:flutter/material.dart';

/// Tarama cercevesi overlay'i — yari saydam arka plan + koseli kare.
class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.black54,
        BlendMode.srcOut,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.red, // srcOut ile kesilecek
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarama cercevesinin koselerini cizer.
class ScannerCornersPainter extends CustomPainter {
  ScannerCornersPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;
    const radius = 24.0;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 280,
      height: 280,
    );

    // Sol ust kose
    canvas
      ..drawArc(
        Rect.fromLTWH(rect.left, rect.top, radius * 2, radius * 2),
        3.14, // pi
        1.5708, // pi/2
        false,
        paint,
      )
      ..drawLine(
        Offset(rect.left, rect.top + radius),
        Offset(rect.left, rect.top + radius + cornerLength),
        paint,
      )
      ..drawLine(
        Offset(rect.left + radius, rect.top),
        Offset(rect.left + radius + cornerLength, rect.top),
        paint,
      )

      // Sag ust kose
      ..drawArc(
        Rect.fromLTWH(
          rect.right - radius * 2,
          rect.top,
          radius * 2,
          radius * 2,
        ),
        -1.5708, // -pi/2
        1.5708,
        false,
        paint,
      )
      ..drawLine(
        Offset(rect.right, rect.top + radius),
        Offset(rect.right, rect.top + radius + cornerLength),
        paint,
      )
      ..drawLine(
        Offset(rect.right - radius, rect.top),
        Offset(rect.right - radius - cornerLength, rect.top),
        paint,
      )

      // Sol alt kose
      ..drawArc(
        Rect.fromLTWH(
          rect.left,
          rect.bottom - radius * 2,
          radius * 2,
          radius * 2,
        ),
        3.14, // pi
        -1.5708,
        false,
        paint,
      )
      ..drawLine(
        Offset(rect.left, rect.bottom - radius),
        Offset(rect.left, rect.bottom - radius - cornerLength),
        paint,
      )
      ..drawLine(
        Offset(rect.left + radius, rect.bottom),
        Offset(rect.left + radius + cornerLength, rect.bottom),
        paint,
      )

      // Sag alt kose
      ..drawArc(
        Rect.fromLTWH(
          rect.right - radius * 2,
          rect.bottom - radius * 2,
          radius * 2,
          radius * 2,
        ),
        0,
        1.5708,
        false,
        paint,
      )
      ..drawLine(
        Offset(rect.right, rect.bottom - radius),
        Offset(rect.right, rect.bottom - radius - cornerLength),
        paint,
      )
      ..drawLine(
        Offset(rect.right - radius, rect.bottom),
        Offset(rect.right - radius - cornerLength, rect.bottom),
        paint,
      );
  }

  @override
  bool shouldRepaint(ScannerCornersPainter oldDelegate) =>
      color != oldDelegate.color;
}
