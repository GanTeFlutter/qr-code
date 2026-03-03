import 'package:flutter/services.dart';

/// Her alan türü için formatter listesi ve validator fonksiyonu
/// sağlayan merkezi validasyon servisi.
typedef FieldValidation = ({
  List<TextInputFormatter> formatters,
  String? Function(String) validator,
});

abstract final class FieldValidators {
  // ── Telefon ──────────────────────────────────────────────
  static FieldValidation phone() => (
        formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]'))],
        validator: (v) {
          final digits = v.replaceAll(RegExp('[^0-9]'), '');
          if (digits.length < 7) return 'validation.invalid_phone';
          return null;
        },
      );

  // ── E-posta ──────────────────────────────────────────────
  static FieldValidation email() => (
        formatters: <TextInputFormatter>[],
        validator: (v) {
          final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          if (!pattern.hasMatch(v)) return 'validation.invalid_email';
          return null;
        },
      );

  // ── URL ──────────────────────────────────────────────────
  static FieldValidation url() => (
        formatters: <TextInputFormatter>[],
        validator: (v) {
          if (!v.startsWith('http://') && !v.startsWith('https://')) {
            return 'validation.invalid_url';
          }
          return null;
        },
      );

  // ── Enlem ────────────────────────────────────────────────
  static FieldValidation latitude() => (
        formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))],
        validator: (v) {
          final n = double.tryParse(v);
          if (n == null || n < -90 || n > 90) {
            return 'validation.invalid_latitude';
          }
          return null;
        },
      );

  // ── Boylam ───────────────────────────────────────────────
  static FieldValidation longitude() => (
        formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))],
        validator: (v) {
          final n = double.tryParse(v);
          if (n == null || n < -180 || n > 180) {
            return 'validation.invalid_longitude';
          }
          return null;
        },
      );

  // ── Miktar ───────────────────────────────────────────────
  static FieldValidation amount() => (
        formatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
        validator: (v) {
          final n = double.tryParse(v);
          if (n == null || n <= 0) return 'validation.invalid_amount';
          return null;
        },
      );

  // ── Kullanıcı adı ───────────────────────────────────────
  static FieldValidation username() => (
        formatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9._]'))],
        validator: (v) {
          if (v.isEmpty) return 'validation.invalid_username';
          return null;
        },
      );

  // ── Cüzdan adresi ───────────────────────────────────────
  static FieldValidation walletAddress() => (
        formatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))],
        validator: (v) {
          if (v.length < 20) return 'validation.invalid_wallet';
          return null;
        },
      );

  // ── Mağaza URL ───────────────────────────────────────────
  static FieldValidation storeUrl() => (
        formatters: <TextInputFormatter>[],
        validator: (v) {
          if (!v.startsWith('http://') && !v.startsWith('https://')) {
            return 'validation.invalid_store_url';
          }
          return null;
        },
      );
}
