import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';

/// QR kodunu SVG string olarak uretir.
/// Harici paket gerektirmez — `qr` paketinin matris verisini kullanir.
class QrSvgExporter {
  /// SVG string uretir.
  String generate({
    required String qrData,
    Color fgColor = const Color(0xFF1A1A2E),
    Color bgColor = const Color(0xFFFFFFFF),
    DotStyle dotStyle = DotStyle.square,
    FrameStyle frameStyle = FrameStyle.none,
    Uint8List? centerLogo,
  }) {
    final hasLogo = centerLogo != null;
    final qrCode = QrCode.fromData(
      data: qrData,
      errorCorrectLevel:
          hasLogo ? QrErrorCorrectLevel.H : QrErrorCorrectLevel.M,
    );
    final qrImage = QrImage(qrCode);
    final moduleCount = qrImage.moduleCount;

    const padding = 16.0;
    final frameInset = frameStyle == FrameStyle.none ? 0.0 : 10.0;
    const qrAreaSize = 260.0;
    final totalSize = qrAreaSize + frameInset * 2;
    const qrSize = qrAreaSize - padding * 2;
    final moduleSize = qrSize / moduleCount;

    final fg = _colorToHex(fgColor);
    final bg = _colorToHex(bgColor);

    final buffer = StringBuffer()
      ..writeln(
        '<svg xmlns="http://www.w3.org/2000/svg" '
        'width="$totalSize" height="$totalSize" '
        'viewBox="0 0 $totalSize $totalSize">',
      )
      ..writeln(
        '  <rect x="$frameInset" y="$frameInset" '
        'width="$qrAreaSize" height="$qrAreaSize" '
        'rx="12" fill="$bg"/>',
      );

    // Cerceve
    if (frameStyle != FrameStyle.none) {
      _writeFrame(buffer, frameStyle, totalSize, fg);
    }

    // Logo icin ortadaki bolgeyi hesapla
    final logoModuleCount = hasLogo ? (moduleCount * 0.22).ceil() : 0;
    final logoStart =
        hasLogo ? ((moduleCount - logoModuleCount) / 2).floor() : 0;
    final logoEnd = hasLogo ? logoStart + logoModuleCount : 0;

    // QR modulleri
    for (var y = 0; y < moduleCount; y++) {
      for (var x = 0; x < moduleCount; x++) {
        if (hasLogo &&
            x >= logoStart &&
            x < logoEnd &&
            y >= logoStart &&
            y < logoEnd) {
          continue;
        }

        if (qrImage.isDark(y, x)) {
          final px = frameInset + padding + x * moduleSize;
          final py = frameInset + padding + y * moduleSize;

          switch (dotStyle) {
            case DotStyle.square:
              buffer.writeln(
                '  <rect x="$px" y="$py" '
                'width="$moduleSize" height="$moduleSize" fill="$fg"/>',
              );
            case DotStyle.round:
              final r = moduleSize * 0.35;
              buffer.writeln(
                '  <rect x="$px" y="$py" '
                'width="$moduleSize" height="$moduleSize" '
                'rx="$r" fill="$fg"/>',
              );
            case DotStyle.dot:
              final cx = px + moduleSize / 2;
              final cy = py + moduleSize / 2;
              final r = moduleSize * 0.4;
              buffer.writeln(
                '  <circle cx="$cx" cy="$cy" r="$r" fill="$fg"/>',
              );
          }
        }
      }
    }

    // Logo
    if (hasLogo) {
      final logoAreaSize = logoModuleCount * moduleSize;
      final logoAreaLeft = frameInset + padding + logoStart * moduleSize;
      final logoAreaTop = frameInset + padding + logoStart * moduleSize;
      final logoPadding = moduleSize * 1.2;

      // Beyaz padding arka plani
      final bgCx = logoAreaLeft + logoAreaSize / 2;
      final bgCy = logoAreaTop + logoAreaSize / 2;
      final bgW = logoAreaSize + logoPadding;
      final bgH = logoAreaSize + logoPadding;
      buffer.writeln(
        '  <rect x="${bgCx - bgW / 2}" y="${bgCy - bgH / 2}" '
        'width="$bgW" height="$bgH" '
        'rx="${moduleSize * 2}" fill="$bg"/>',
      );

      // Logo resmi (base64)
      final base64Logo = base64Encode(centerLogo);
      buffer.writeln(
        '  <image x="$logoAreaLeft" y="$logoAreaTop" '
        'width="$logoAreaSize" height="$logoAreaSize" '
        'href="data:image/png;base64,$base64Logo" '
        'clip-path="inset(0 round ${moduleSize * 1.5}px)"/>',
      );
    }

    buffer.writeln('</svg>');
    return buffer.toString();
  }

  void _writeFrame(
    StringBuffer buffer,
    FrameStyle style,
    double totalSize,
    String fg,
  ) {
    const strokeWidth = 3.0;
    const half = strokeWidth / 2;

    switch (style) {
      case FrameStyle.none:
        break;
      case FrameStyle.solid:
        buffer.writeln(
          '  <rect x="$half" y="$half" '
          'width="${totalSize - strokeWidth}" '
          'height="${totalSize - strokeWidth}" '
          'fill="none" stroke="$fg" stroke-width="$strokeWidth"/>',
        );
      case FrameStyle.rounded:
        buffer.writeln(
          '  <rect x="$half" y="$half" '
          'width="${totalSize - strokeWidth}" '
          'height="${totalSize - strokeWidth}" '
          'rx="16" fill="none" stroke="$fg" stroke-width="$strokeWidth"/>',
        );
      case FrameStyle.dashed:
        buffer.writeln(
          '  <rect x="$half" y="$half" '
          'width="${totalSize - strokeWidth}" '
          'height="${totalSize - strokeWidth}" '
          'rx="0" fill="none" stroke="$fg" '
          'stroke-width="$strokeWidth" '
          'stroke-dasharray="8 5" stroke-linecap="round"/>',
        );
      case FrameStyle.shadow:
        // Golge
        buffer.writeln(
          '  <rect x="${half + 2}" y="${half + 2}" '
          'width="${totalSize - strokeWidth}" '
          'height="${totalSize - strokeWidth}" '
          'rx="12" fill="none" stroke="$fg" '
          'stroke-opacity="0.2" stroke-width="${strokeWidth + 2}"/>',
        );
        // Ana cerceve
        buffer.writeln(
          '  <rect x="$half" y="$half" '
          'width="${totalSize - strokeWidth}" '
          'height="${totalSize - strokeWidth}" '
          'rx="12" fill="none" stroke="$fg" stroke-width="$strokeWidth"/>',
        );
      case FrameStyle.elegant:
        // Dis cizgi
        buffer.writeln(
          '  <rect x="$half" y="$half" '
          'width="${totalSize - strokeWidth}" '
          'height="${totalSize - strokeWidth}" '
          'rx="14" fill="none" stroke="$fg" stroke-width="$strokeWidth"/>',
        );
        // Ic cizgi
        const innerInset = strokeWidth + 3;
        buffer.writeln(
          '  <rect x="$innerInset" y="$innerInset" '
          'width="${totalSize - innerInset * 2}" '
          'height="${totalSize - innerInset * 2}" '
          'rx="10" fill="none" stroke="$fg" '
          'stroke-opacity="0.5" stroke-width="1.5"/>',
        );
    }
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
