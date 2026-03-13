import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/service/qr_svg_exporter.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/product/enum/history_source.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';
import 'package:share_plus/share_plus.dart';

/// QR kodunu PNG/SVG olarak disa aktaran servis.
final class QrExportService {
  const QrExportService._();

  /// RepaintBoundary'den PNG dosyasi olusturur.
  static Future<File> exportPng(GlobalKey repaintKey) async {
    final boundary =
        repaintKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  /// PNG olarak galeriye kaydeder ve gecmise ekler.
  static Future<void> saveToGallery({
    required GlobalKey repaintKey,
    required CreateQrState state,
  }) async {
    final file = await exportPng(repaintKey);
    await Gal.putImage(file.path);
    await HapticFeedback.mediumImpact();

    final type = state.selectedType ?? QrType.text;
    locator.historyService.addToHistory(
      content: state.qrContent,
      qrType: type,
      source: HistorySource.created,
      title: titleForContent(type, state.formData),
    );
  }

  /// PNG olarak paylas diyalogu acar.
  static Future<void> share(GlobalKey repaintKey) async {
    final file = await exportPng(repaintKey);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  /// SVG olarak kaydeder.
  static Future<void> saveSvg(CreateQrState state) async {
    final svgString = QrSvgExporter().generate(
      qrData: state.qrContent,
      fgColor: state.fgColor,
      bgColor: state.bgColor,
      dotStyle: state.dotStyle,
      frameStyle: state.frameStyle,
      centerLogo: state.centerLogo,
    );

    final fileName = 'qr_${DateTime.now().millisecondsSinceEpoch}.svg';

    if (Platform.isAndroid) {
      Directory? svgDir;
      try {
        svgDir = Directory('/storage/emulated/0/Download/QR Codes');
        if (!svgDir.existsSync()) svgDir.createSync();
      } on FileSystemException {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          svgDir = Directory('${extDir.path}/QR Codes');
          if (!svgDir.existsSync()) svgDir.createSync();
        }
      }

      if (svgDir != null) {
        final nomedia = File('${svgDir.path}/.nomedia');
        if (!nomedia.existsSync()) nomedia.createSync();

        final file = File('${svgDir.path}/$fileName');
        await file.writeAsString(svgString);
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final svgDir = Directory('${dir.path}/QR Codes');
      if (!svgDir.existsSync()) svgDir.createSync();
      final file = File('${svgDir.path}/$fileName');
      await file.writeAsString(svgString);
    }

    await HapticFeedback.mediumImpact();
  }

  /// QR tipi ve form verisinden baslik uretir.
  static String titleForContent(QrType type, Map<String, String> formData) {
    switch (type) {
      case QrType.url:
        return formData['url'] ?? '';
      case QrType.text:
        final text = formData['text'] ?? '';
        return text.length > 50 ? text.substring(0, 50) : text;
      case QrType.wifi:
        return formData['ssid'] ?? '';
      case QrType.phone:
        return formData['phone'] ?? '';
      case QrType.sms:
        return formData['phone'] ?? '';
      case QrType.email:
        return formData['email'] ?? '';
      case QrType.vcard:
        return formData['name'] ?? '';
      case QrType.location:
        final lat = formData['latitude'] ?? '';
        final lng = formData['longitude'] ?? '';
        return '$lat, $lng';
      case QrType.social:
        final platform = formData['platform'] ?? 'instagram';
        final username = formData['username'] ?? '';
        return '$platform: $username';
      case QrType.appStore:
        return formData['store_url'] ?? '';
      case QrType.crypto:
        final coin = formData['coin'] ?? 'bitcoin';
        final address = formData['address'] ?? '';
        return '$coin: $address';
    }
  }
}
