import 'package:flutter/services.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/model/scan_result_type.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Taranan QR icerigine gore akilli aksiyon servisi.
final class SmartActionService {
  SmartActionService._();

  /// Tur bazli birincil aksiyonu calistirir.
  static Future<bool> launchAction(
    ScanResultType type,
    String content,
  ) async {
    final uri = switch (type) {
      ScanResultType.url => Uri.tryParse(content),
      ScanResultType.phone => Uri.tryParse(
        'tel:${content.replaceFirst(RegExp('^tel:', caseSensitive: false), '')}',
      ),
      ScanResultType.email => Uri.tryParse(
        content.startsWith('mailto:') ? content : 'mailto:$content',
      ),
      ScanResultType.sms => _buildSmsUri(content),
      ScanResultType.location => _buildGeoUri(content),
      ScanResultType.social => Uri.tryParse(content),
      ScanResultType.appStore => Uri.tryParse(content),
      ScanResultType.crypto => Uri.tryParse(content),
      _ => null,
    };

    if (uri == null) return false;

    // canLaunchUrl, Android 11+ package visibility kisitlamasi nedeniyle
    // guvenilmez. Dogrudan launchUrl cagirip hatayi yakaliyoruz.
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }

  /// Icerigi panoya kopyalar.
  static Future<void> copyToClipboard(String content) {
    return Clipboard.setData(ClipboardData(text: content));
  }

  /// Icerigi paylas diyalogu ile paylasir.
  static Future<void> shareContent(String content) {
    return SharePlus.instance.share(ShareParams(text: content));
  }

  static Uri? _buildSmsUri(String content) {
    final body = content.replaceFirst(
      RegExp('^(smsto:|sms:)', caseSensitive: false),
      '',
    );
    final sep = body.indexOf(':');
    if (sep == -1) return Uri.tryParse('sms:$body');
    final phone = body.substring(0, sep);
    final message = body.substring(sep + 1);
    return Uri(scheme: 'sms', path: phone, queryParameters: {'body': message});
  }

  static Uri? _buildGeoUri(String content) {
    if (content.toLowerCase().startsWith('geo:')) {
      return Uri.tryParse(content);
    }
    return null;
  }
}
