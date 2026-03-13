import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/about_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/animation_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/contact_us_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/language_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/rate_app_tile.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/settings_section.dart';
import 'package:qrcode_akillisletme/feature/settings/widget/share_app_tile.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/theme/widget/theme_setting_tile.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.home_settings.tr())),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: context.r(16),
          vertical: context.r(8),
        ),
        children: [
          SettingsSection(
            title: LocaleKeys.settings_appearance.tr(),
            children: const [
              ThemeSettingTile(),
              LanguageTile(),
              AnimationTile(),
            ],
          ),
          SizedBox(height: context.r(16)),
          SettingsSection(
            title: LocaleKeys.settings_support.tr(),
            children: const [
              ContactUsTile(),
              RateAppTile(),
              ShareAppTile(),
            ],
          ),
          SizedBox(height: context.r(16)),
          const SettingsSection(
            children: [
              AboutTile(),
            ],
          ),
        ],
      ),
    );
  }
}
