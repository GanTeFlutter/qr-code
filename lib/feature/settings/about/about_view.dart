import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/settings/about/widget/about_link_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/about/widget/version_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/settings_section.dart';
import 'package:qrcode_akillisletme/product/const/app_string.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settings_aboutTitle.tr())),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: context.r(16),
          vertical: context.r(8),
        ),
        children: [
          SettingsSection(
            title: LocaleKeys.settings_legalAndPolicies.tr(),
            children: [
              AboutLinkTile(
                title: LocaleKeys.settings_privacyPolicy.tr(),
                url: AppString.privacyPolicyUrl,
                icon: Icons.privacy_tip_outlined,
              ),
            ],
          ),
          SizedBox(height: context.r(16)),
          const SettingsSection(
            children: [
              VersionTile(),
            ],
          ),
        ],
      ),
    );
  }
}
