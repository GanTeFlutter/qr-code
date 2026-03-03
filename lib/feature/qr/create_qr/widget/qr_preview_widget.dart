import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr/qr.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';

/// QR kodu CustomPainter ile cizen widget.
/// [repaintKey] ile PNG export yapilabilir.
class QrPreviewWidget extends StatefulWidget {
  const QrPreviewWidget({
    required this.data,
    required this.repaintKey,
    this.size = 220,
    this.fgColor = const Color(0xFF1A1A2E),
    this.bgColor = const Color(0xFFFFFFFF),
    this.dotStyle = DotStyle.square,
    this.frameStyle = FrameStyle.none,
    this.centerLogo,
    super.key,
  });

  final String data;
  final GlobalKey repaintKey;
  final double size;
  final Color fgColor;
  final Color bgColor;
  final DotStyle dotStyle;
  final FrameStyle frameStyle;
  final Uint8List? centerLogo;

  /// QR widget'ini PNG byte'larina cevirir.
  Future<ui.Image> toImage() async {
    final boundary = repaintKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    return boundary.toImage(pixelRatio: 3);
  }

  @override
  State<QrPreviewWidget> createState() => _QrPreviewWidgetState();
}

class _QrPreviewWidgetState extends State<QrPreviewWidget> {
  ui.Image? _logoImage;
  Uint8List? _lastLogoBytes;

  @override
  void didUpdateWidget(covariant QrPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.centerLogo != oldWidget.centerLogo) {
      _decodeLogoImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _decodeLogoImage();
  }

  Future<void> _decodeLogoImage() async {
    final bytes = widget.centerLogo;
    if (bytes == null) {
      if (_logoImage != null) {
        setState(() {
          _logoImage = null;
          _lastLogoBytes = null;
        });
      }
      return;
    }
    if (bytes == _lastLogoBytes) return;
    _lastLogoBytes = bytes;

    try {
      // Resmi max 512x512'ye olcekle — bellek tasmasini onler
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 512,
        targetHeight: 512,
      );
      final frame = await codec.getNextFrame();
      debugPrint(
        '[QrPreview] Logo decode OK: '
        '${frame.image.width}x${frame.image.height}',
      );
      if (mounted && widget.centerLogo == bytes) {
        setState(() => _logoImage = frame.image);
      }
    } on Exception catch (e, stack) {
      debugPrint('[QrPreview] Logo decode hatasi: $e');
      debugPrint('[QrPreview] Stack: $stack');
      _lastLogoBytes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return SizedBox.square(dimension: widget.size);

    final hasLogo = widget.centerLogo != null;
    final qrCode = QrCode.fromData(
      data: widget.data,
      errorCorrectLevel:
          hasLogo ? QrErrorCorrectLevel.H : QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);

    final frameInset = widget.frameStyle == FrameStyle.none ? 0.0 : 10.0;
    final totalSize = widget.size + frameInset * 2;

    return RepaintBoundary(
      key: widget.repaintKey,
      child: CustomPaint(
        size: Size.square(totalSize),
        painter: _QrPainter(
          qrImage: qrImage,
          fgColor: widget.fgColor,
          bgColor: widget.bgColor,
          dotStyle: widget.dotStyle,
          frameStyle: widget.frameStyle,
          logoImage: _logoImage,
          frameInset: frameInset,
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter({
    required this.qrImage,
    required this.fgColor,
    required this.bgColor,
    required this.dotStyle,
    required this.frameStyle,
    required this.frameInset,
    this.logoImage,
  });

  final QrImage qrImage;
  final Color fgColor;
  final Color bgColor;
  final DotStyle dotStyle;
  final FrameStyle frameStyle;
  final double frameInset;
  final ui.Image? logoImage;

  @override
  void paint(Canvas canvas, Size size) {
    // ── Arka plan + çerçeve ───────────────────────────────────
    final qrAreaRect = Rect.fromLTWH(
      frameInset,
      frameInset,
      size.width - frameInset * 2,
      size.height - frameInset * 2,
    );

    // QR arka planı
    canvas.drawRRect(
      RRect.fromRectAndRadius(qrAreaRect, const Radius.circular(12)),
      Paint()..color = bgColor,
    );

    // Çerçeve
    if (frameStyle != FrameStyle.none) {
      _drawFrame(canvas, size);
    }

    // ── QR modülleri ──────────────────────────────────────────
    const padding = 16.0;
    final qrSize = qrAreaRect.width - padding * 2;
    final moduleCount = qrImage.moduleCount;
    final moduleSize = qrSize / moduleCount;
    final paint = Paint()..color = fgColor;

    // Logo için ortadaki bölgeyi hesapla
    final logoModuleCount =
        logoImage != null ? (moduleCount * 0.22).ceil() : 0;
    final logoStart =
        logoImage != null ? ((moduleCount - logoModuleCount) / 2).floor() : 0;
    final logoEnd =
        logoImage != null ? logoStart + logoModuleCount : 0;

    for (var y = 0; y < moduleCount; y++) {
      for (var x = 0; x < moduleCount; x++) {
        // Logo bölgesindeki modülleri atla
        if (logoImage != null &&
            x >= logoStart &&
            x < logoEnd &&
            y >= logoStart &&
            y < logoEnd) {
          continue;
        }

        if (qrImage.isDark(y, x)) {
          final rect = Rect.fromLTWH(
            qrAreaRect.left + padding + x * moduleSize,
            qrAreaRect.top + padding + y * moduleSize,
            moduleSize,
            moduleSize,
          );

          switch (dotStyle) {
            case DotStyle.square:
              canvas.drawRect(rect, paint);
            case DotStyle.round:
              canvas.drawRRect(
                RRect.fromRectAndRadius(
                  rect,
                  Radius.circular(moduleSize * 0.35),
                ),
                paint,
              );
            case DotStyle.dot:
              canvas.drawCircle(
                rect.center,
                moduleSize * 0.4,
                paint,
              );
          }
        }
      }
    }

    // ── Logo çizimi ───────────────────────────────────────────
    if (logoImage != null) {
      final logoAreaSize = logoModuleCount * moduleSize;
      final logoAreaLeft =
          qrAreaRect.left + padding + logoStart * moduleSize;
      final logoAreaTop =
          qrAreaRect.top + padding + logoStart * moduleSize;

      // Beyaz padding arka planı
      final logoPadding = moduleSize * 1.2;
      final bgRect = Rect.fromCenter(
        center: Offset(
          logoAreaLeft + logoAreaSize / 2,
          logoAreaTop + logoAreaSize / 2,
        ),
        width: logoAreaSize + logoPadding,
        height: logoAreaSize + logoPadding,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, Radius.circular(moduleSize * 2)),
        Paint()..color = bgColor,
      );

      // Logo
      final logoRect = Rect.fromCenter(
        center: bgRect.center,
        width: logoAreaSize,
        height: logoAreaSize,
      );
      final srcRect = Rect.fromLTWH(
        0,
        0,
        logoImage!.width.toDouble(),
        logoImage!.height.toDouble(),
      );

      canvas
        ..save()
        ..clipRRect(
          RRect.fromRectAndRadius(
            logoRect,
            Radius.circular(moduleSize * 1.5),
          ),
        )
        ..drawImageRect(logoImage!, srcRect, logoRect, Paint())
        ..restore();
    }
  }

  void _drawFrame(Canvas canvas, Size size) {
    final frameRect = Rect.fromLTWH(0, 0, size.width, size.height);
    const strokeWidth = 3.0;

    switch (frameStyle) {
      case FrameStyle.none:
        break;
      case FrameStyle.solid:
        canvas.drawRect(
          frameRect.deflate(strokeWidth / 2),
          Paint()
            ..color = fgColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth,
        );
      case FrameStyle.rounded:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            frameRect.deflate(strokeWidth / 2),
            const Radius.circular(16),
          ),
          Paint()
            ..color = fgColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth,
        );
      case FrameStyle.dashed:
        _drawDashedRect(canvas, frameRect.deflate(strokeWidth / 2),
            strokeWidth);
      case FrameStyle.shadow:
        // Gölge
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            frameRect.deflate(strokeWidth / 2).shift(const Offset(2, 2)),
            const Radius.circular(12),
          ),
          Paint()
            ..color = fgColor.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 2,
        );
        // Ana çerçeve
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            frameRect.deflate(strokeWidth / 2),
            const Radius.circular(12),
          ),
          Paint()
            ..color = fgColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth,
        );
      case FrameStyle.elegant:
        // Dış çizgi
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            frameRect.deflate(strokeWidth / 2),
            const Radius.circular(14),
          ),
          Paint()
            ..color = fgColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth,
        );
        // İç çizgi
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            frameRect.deflate(strokeWidth + 3),
            const Radius.circular(10),
          ),
          Paint()
            ..color = fgColor.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, double strokeWidth) {
    final paint = Paint()
      ..color = fgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const dashLength = 8.0;
    const gapLength = 5.0;

    final path = Path()..addRect(rect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = min(distance + dashLength, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter oldDelegate) =>
      fgColor != oldDelegate.fgColor ||
      bgColor != oldDelegate.bgColor ||
      dotStyle != oldDelegate.dotStyle ||
      frameStyle != oldDelegate.frameStyle ||
      logoImage != oldDelegate.logoImage ||
      qrImage != oldDelegate.qrImage;
}
