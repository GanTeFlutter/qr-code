import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/settings/language_selection/widget/language_grid_content.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// Onboarding Step 1 — Language Selection
class Step1 extends StatelessWidget {
  const Step1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = screenWidth > 600 ? 540.0 : double.infinity;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.r(24),
            vertical: context.r(16),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  SizedBox(height: context.r(24)),
                  Text(
                    LocaleKeys.language_chooseYourLanguage.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.r(8)),
                  Text(
                    LocaleKeys.language_selectPreferredLanguage.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.r(24)),
                  const LanguageGridContent(),
                  SizedBox(height: context.r(80)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
