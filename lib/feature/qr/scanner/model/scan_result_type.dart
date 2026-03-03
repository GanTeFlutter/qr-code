import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';

/// Taranan QR iceriginin tur algisini yapar.
enum ScanResultType {
  url(icon: Icons.link_rounded, labelKey: LocaleKeys.create_qr_types_url),
  text(
    icon: Icons.edit_note_rounded,
    labelKey: LocaleKeys.create_qr_types_text,
  ),
  wifi(icon: Icons.wifi_rounded, labelKey: LocaleKeys.create_qr_types_wifi),
  phone(
    icon: Icons.phone_rounded,
    labelKey: LocaleKeys.create_qr_types_phone,
  ),
  sms(
    icon: Icons.chat_bubble_outline_rounded,
    labelKey: LocaleKeys.create_qr_types_sms,
  ),
  email(
    icon: Icons.email_outlined,
    labelKey: LocaleKeys.create_qr_types_email,
  ),
  vcard(
    icon: Icons.person_outline_rounded,
    labelKey: LocaleKeys.create_qr_types_vcard,
  ),
  location(
    icon: Icons.location_on_outlined,
    labelKey: LocaleKeys.create_qr_types_location,
  ),
  social(
    icon: Icons.share_rounded,
    labelKey: LocaleKeys.create_qr_types_social,
  ),
  appStore(
    icon: Icons.store_rounded,
    labelKey: LocaleKeys.create_qr_types_appStore,
  ),
  crypto(
    icon: Icons.currency_bitcoin_rounded,
    labelKey: LocaleKeys.create_qr_types_crypto,
  );

  const ScanResultType({required this.icon, required this.labelKey});

  final IconData icon;
  final String labelKey;

  /// Gecmis kayit icin QrType eslestirmesi.
  QrType toQrType() => switch (this) {
    ScanResultType.url => QrType.url,
    ScanResultType.text => QrType.text,
    ScanResultType.wifi => QrType.wifi,
    ScanResultType.phone => QrType.phone,
    ScanResultType.sms => QrType.sms,
    ScanResultType.email => QrType.email,
    ScanResultType.vcard => QrType.vcard,
    ScanResultType.location => QrType.location,
    ScanResultType.social => QrType.social,
    ScanResultType.appStore => QrType.appStore,
    ScanResultType.crypto => QrType.crypto,
  };

  /// Taranan string iceriginin turunu algilar.
  static ScanResultType detect(String content) {
    final trimmed = content.trim();
    final lower = trimmed.toLowerCase();

    // Wi-Fi
    if (lower.startsWith('wifi:')) return ScanResultType.wifi;

    // vCard
    if (lower.startsWith('begin:vcard')) return ScanResultType.vcard;

    // Telefon
    if (lower.startsWith('tel:')) return ScanResultType.phone;

    // SMS
    if (lower.startsWith('smsto:') || lower.startsWith('sms:')) {
      return ScanResultType.sms;
    }

    // E-posta
    if (lower.startsWith('mailto:')) return ScanResultType.email;
    if (_emailRegex.hasMatch(trimmed)) return ScanResultType.email;

    // Konum
    if (lower.startsWith('geo:')) return ScanResultType.location;

    // Kripto
    if (_cryptoRegex.hasMatch(lower)) return ScanResultType.crypto;

    // URL tabanli turler
    if (_urlRegex.hasMatch(lower)) {
      // Sosyal medya
      if (_socialHosts.any(lower.contains)) return ScanResultType.social;

      // Uygulama magazasi
      if (_storeHosts.any(lower.contains)) return ScanResultType.appStore;

      return ScanResultType.url;
    }

    // Telefon numarasi pattern'i (+ ile baslar veya sadece rakam)
    if (_phoneRegex.hasMatch(trimmed)) return ScanResultType.phone;

    return ScanResultType.text;
  }

  static final _urlRegex = RegExp('^https?://', caseSensitive: false);
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?[\d\s\-()]{7,}$');
  static final _cryptoRegex = RegExp(
    '^(bitcoin|ethereum|litecoin|bitcoincash):',
  );
  static const _socialHosts = [
    'instagram.com',
    'twitter.com',
    'x.com',
    'facebook.com',
    'linkedin.com',
    'tiktok.com',
    'youtube.com',
  ];
  static const _storeHosts = [
    'apps.apple.com',
    'play.google.com',
    'appgallery.huawei.com',
  ];
}
