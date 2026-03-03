import 'package:flutter/material.dart';

/// QR kod turleri.
enum QrType {
  url(icon: Icons.link_rounded),
  text(icon: Icons.edit_note_rounded),
  wifi(icon: Icons.wifi_rounded),
  phone(icon: Icons.phone_rounded),
  sms(icon: Icons.chat_bubble_outline_rounded),
  email(icon: Icons.email_outlined),
  vcard(icon: Icons.person_outline_rounded),
  location(icon: Icons.location_on_outlined),
  social(icon: Icons.share_rounded),
  appStore(icon: Icons.store_rounded),
  crypto(icon: Icons.currency_bitcoin_rounded);

  const QrType({required this.icon});

  final IconData icon;
}
