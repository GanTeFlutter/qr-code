import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/init/language/core_localize.dart';

@immutable
class LanguageItem {
  const LanguageItem({
    required this.flag,
    required this.nativeName,
    required this.appLocale,
  });

  final String flag;
  final String nativeName;
  final AppLocale appLocale;

  Locale get locale => appLocale.locale;

  static const List<LanguageItem> all = [
    LanguageItem(flag: '\u{1F1F9}\u{1F1F7}', nativeName: 'T\u00fcrk\u00e7e', appLocale: AppLocale.tr),
    LanguageItem(flag: '\u{1F1FA}\u{1F1F8}', nativeName: 'English', appLocale: AppLocale.en),
    LanguageItem(flag: '\u{1F1F8}\u{1F1E6}', nativeName: '\u0627\u0644\u0639\u0631\u0628\u064A\u0629', appLocale: AppLocale.ar),
    LanguageItem(flag: '\u{1F1E9}\u{1F1EA}', nativeName: 'Deutsch', appLocale: AppLocale.de),
    LanguageItem(flag: '\u{1F1EA}\u{1F1F8}', nativeName: 'Espa\u00f1ol', appLocale: AppLocale.es),
    LanguageItem(flag: '\u{1F1EB}\u{1F1F7}', nativeName: 'Fran\u00e7ais', appLocale: AppLocale.fr),
    LanguageItem(flag: '\u{1F1EE}\u{1F1F3}', nativeName: '\u0939\u093F\u0928\u094D\u0926\u0940', appLocale: AppLocale.hi),
    LanguageItem(flag: '\u{1F1EE}\u{1F1E9}', nativeName: 'Indonesia', appLocale: AppLocale.id),
    LanguageItem(flag: '\u{1F1EE}\u{1F1F9}', nativeName: 'Italiano', appLocale: AppLocale.it),
    LanguageItem(flag: '\u{1F1EF}\u{1F1F5}', nativeName: '\u65E5\u672C\u8A9E', appLocale: AppLocale.ja),
    LanguageItem(flag: '\u{1F1F0}\u{1F1F7}', nativeName: '\uD55C\uAD6D\uC5B4', appLocale: AppLocale.ko),
    LanguageItem(flag: '\u{1F1E7}\u{1F1F7}', nativeName: 'Portugu\u00eas', appLocale: AppLocale.pt),
    LanguageItem(flag: '\u{1F1F7}\u{1F1FA}', nativeName: '\u0420\u0443\u0441\u0441\u043A\u0438\u0439', appLocale: AppLocale.ru),
    LanguageItem(flag: '\u{1F1E8}\u{1F1F3}', nativeName: '\u4E2D\u6587', appLocale: AppLocale.zh),
  ];
}
