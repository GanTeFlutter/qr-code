import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/home/home_view_mode.dart';
import 'package:qrcode_akillisletme/feature/home/widget/home_menu_card.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/navigation/app_router.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends HomeViewMode {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.r(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.general_appName.tr(),
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: context.rf(22),
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: context.r(32)),
                // Hero card — QR Tara
                HomeMenuCard(
                  icon: Icons.qr_code_scanner,
                  title: LocaleKeys.home_scan.tr(),
                  description: LocaleKeys.home_scanDesc.tr(),
                  isHero: true,
                  onTap: () => const ScannerRoute().go(context),
                ),
                SizedBox(height: context.r(20)),
                // 3'lu grid satiri
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 0.85,
                        child: HomeMenuCard(
                          icon: Icons.add_box_outlined,
                          title: LocaleKeys.home_create.tr(),
                          description: LocaleKeys.home_createDesc.tr(),
                          onTap: () => const CreateQrRoute().go(context),
                        ),
                      ),
                    ),
                    SizedBox(width: context.r(12)),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 0.85,
                        child: HomeMenuCard(
                          icon: Icons.history,
                          title: LocaleKeys.home_history.tr(),
                          description: LocaleKeys.home_historyDesc.tr(),
                          onTap: () => const HistoryRoute().go(context),
                        ),
                      ),
                    ),
                    SizedBox(width: context.r(12)),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 0.85,
                        child: HomeMenuCard(
                          icon: Icons.settings_outlined,
                          title: LocaleKeys.home_settings.tr(),
                          description: LocaleKeys.home_settingsDesc.tr(),
                          onTap: () => const SettingsRoute().go(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
