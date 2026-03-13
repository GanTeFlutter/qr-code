import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/navigation/app_router.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(Icons.info_outline_rounded, color: cs.onSurfaceVariant),
      title: Text(LocaleKeys.settings_about.tr()),
      onTap: () => const AboutRoute().push<void>(context),
    );
  }
}
