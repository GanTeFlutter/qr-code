import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';

class RateAppTile extends StatelessWidget {
  const RateAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(Icons.star_outline_rounded, color: cs.onSurfaceVariant),
      title: Text(LocaleKeys.settings_rateApp.tr()),
      onTap: () => locator.urlLauncher.openStore(),
    );
  }
}
