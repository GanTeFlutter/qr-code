import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// Onboarding Step 4 — Create QR Codes
class Step4 extends StatelessWidget {
  const Step4({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.r(32),
          vertical: context.r(16),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                SizedBox(height: context.r(48)),
                // Icon
                Container(
                  width: context.r(100),
                  height: context.r(100),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_box_outlined,
                    size: context.r(52),
                    color: cs.onSecondaryContainer,
                  ),
                ),
                SizedBox(height: context.r(32)),
                // Title
                Text(
                  LocaleKeys.onboarding_step4Title.tr(),
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.r(12)),
                // Description
                Text(
                  LocaleKeys.onboarding_step4Desc.tr(),
                  style: tt.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.r(36)),
                // Features
                _FeatureItem(
                  icon: Icons.palette_rounded,
                  text: LocaleKeys.onboarding_customize_feature.tr(),
                ),
                SizedBox(height: context.r(16)),
                _FeatureItem(
                  icon: Icons.image_outlined,
                  text: LocaleKeys.onboarding_logo_feature.tr(),
                ),
                SizedBox(height: context.r(16)),
                _FeatureItem(
                  icon: Icons.share_rounded,
                  text: LocaleKeys.onboarding_export_feature.tr(),
                ),
                SizedBox(height: context.r(80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: context.r(44),
          height: context.r(44),
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
          child: Icon(icon, color: cs.onSecondaryContainer, size: context.r(22)),
        ),
        SizedBox(width: context.r(14)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: context.rf(15),
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
