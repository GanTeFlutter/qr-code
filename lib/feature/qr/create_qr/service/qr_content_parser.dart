/// QR content string'ini `Map<String, String>` formData'ya donusturen utility.
final class QrContentParser {
  QrContentParser._();

  /// [content] icerigini [qrTypeName]'e gore parse eder.
  static Map<String, String> parse(String content, String qrTypeName) {
    return switch (qrTypeName) {
      'url' => _parseUrl(content),
      'text' => _parseText(content),
      'wifi' => _parseWifi(content),
      'phone' => _parsePhone(content),
      'sms' => _parseSms(content),
      'email' => _parseEmail(content),
      'vcard' => _parseVcard(content),
      'location' => _parseLocation(content),
      'social' => _parseSocial(content),
      'appStore' => _parseAppStore(content),
      'crypto' => _parseCrypto(content),
      _ => {'text': content},
    };
  }

  static Map<String, String> _parseUrl(String c) => {'url': c};

  static Map<String, String> _parseText(String c) => {'text': c};

  static Map<String, String> _parseWifi(String c) {
    // Format: WIFI:T:WPA;S:MyNet;P:pass;H:true;;
    final result = <String, String>{};
    final body = c.replaceFirst(RegExp('^WIFI:', caseSensitive: false), '');
    for (final part in body.split(';')) {
      if (part.isEmpty) continue;
      final sep = part.indexOf(':');
      if (sep == -1) continue;
      final key = part.substring(0, sep);
      final value = part.substring(sep + 1);
      switch (key) {
        case 'T':
          result['encryption'] = value;
        case 'S':
          result['ssid'] = value;
        case 'P':
          result['password'] = value;
        case 'H':
          result['hidden'] = value;
      }
    }
    return result;
  }

  static Map<String, String> _parsePhone(String c) {
    final phone = c.replaceFirst(RegExp('^tel:', caseSensitive: false), '');
    return {'phone': phone};
  }

  static Map<String, String> _parseSms(String c) {
    // Format: smsto:phone:msg
    final body = c.replaceFirst(RegExp('^smsto:', caseSensitive: false), '');
    final sep = body.indexOf(':');
    if (sep == -1) return {'phone': body, 'message': ''};
    return {
      'phone': body.substring(0, sep),
      'message': body.substring(sep + 1),
    };
  }

  static Map<String, String> _parseEmail(String c) {
    // Format: mailto:email?subject=...&body=...
    final uri = Uri.tryParse(c);
    if (uri == null) return {'email': c};
    return {
      'email': uri.path,
      'subject': uri.queryParameters['subject'] ?? '',
      'message': uri.queryParameters['body'] ?? '',
    };
  }

  static Map<String, String> _parseVcard(String c) {
    final result = <String, String>{};
    for (final line in c.split(RegExp(r'\r?\n'))) {
      if (line.startsWith('FN:')) result['name'] = line.substring(3);
      if (line.startsWith('TEL:')) result['phone'] = line.substring(4);
      if (line.startsWith('EMAIL:')) result['email'] = line.substring(6);
      if (line.startsWith('ORG:')) result['company'] = line.substring(4);
    }
    return result;
  }

  static Map<String, String> _parseLocation(String c) {
    // Format: geo:lat,lng
    final body = c.replaceFirst(RegExp('^geo:', caseSensitive: false), '');
    final parts = body.split(',');
    return {
      'latitude': parts.isNotEmpty ? parts[0] : '',
      'longitude': parts.length > 1 ? parts[1] : '',
    };
  }

  static Map<String, String> _parseSocial(String c) {
    final uri = Uri.tryParse(c);
    if (uri == null) return {'platform': 'instagram', 'username': c};

    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final username =
        segments.isNotEmpty ? segments.last.replaceFirst('@', '') : '';

    final platform = switch (host) {
      _ when host.contains('instagram') => 'instagram',
      _ when host.contains('x.com') || host.contains('twitter') => 'twitter',
      _ when host.contains('facebook') => 'facebook',
      _ when host.contains('linkedin') => 'linkedin',
      _ when host.contains('tiktok') => 'tiktok',
      _ when host.contains('youtube') => 'youtube',
      _ => 'instagram',
    };

    return {'platform': platform, 'username': username};
  }

  static Map<String, String> _parseAppStore(String c) {
    final uri = Uri.tryParse(c);
    if (uri == null) return {'store_platform': 'appStore', 'store_url': c};

    final host = uri.host.toLowerCase();
    final platform = switch (host) {
      _ when host.contains('apple') => 'appStore',
      _ when host.contains('google') || host.contains('play.') => 'playStore',
      _ when host.contains('huawei') || host.contains('appgallery') =>
        'huawei',
      _ => 'appStore',
    };

    return {'store_platform': platform, 'store_url': c};
  }

  static Map<String, String> _parseCrypto(String c) {
    // Format: bitcoin:addr?amount=0.5
    final sep = c.indexOf(':');
    if (sep == -1) return {'coin': 'bitcoin', 'address': c, 'amount': ''};

    final coin = c.substring(0, sep);
    final rest = c.substring(sep + 1);
    final uri = Uri.tryParse('scheme:$rest');

    return {
      'coin': coin,
      'address': uri?.path ?? rest,
      'amount': uri?.queryParameters['amount'] ?? '',
    };
  }
}
