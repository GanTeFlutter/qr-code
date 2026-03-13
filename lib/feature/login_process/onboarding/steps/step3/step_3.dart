import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// Onboarding Step 3 — Scan QR Codes
class Step3 extends StatelessWidget {
  const Step3({super.key});

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
                    color: cs.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: context.r(52),
                    color: cs.onTertiaryContainer,
                  ),
                ),
                SizedBox(height: context.r(32)),
                // Title
                Text(
                  LocaleKeys.onboarding_step3Title.tr(),
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.r(12)),
                // Description
                Text(
                  LocaleKeys.onboarding_step3Desc.tr(),
                  style: tt.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.r(36)),
                // Smart action chips
                Wrap(
                  spacing: context.r(8),
                  runSpacing: context.r(8),
                  alignment: WrapAlignment.center,
                  children: [
                    const _ActionChip(icon: Icons.link_rounded, label: 'URL'),
                    _ActionChip(icon: Icons.phone_rounded, label: LocaleKeys.create_qr_types_phone.tr()),
                    _ActionChip(icon: Icons.email_outlined, label: LocaleKeys.create_qr_types_email.tr()),
                    const _ActionChip(icon: Icons.wifi_rounded, label: 'Wi-Fi'),
                    _ActionChip(icon: Icons.person_outline_rounded, label: LocaleKeys.create_qr_types_vcard.tr()),
                    _ActionChip(icon: Icons.location_on_outlined, label: LocaleKeys.create_qr_types_location.tr()),
                  ],
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

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(14),
        vertical: context.r(8),
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.r(16), color: cs.primary),
          SizedBox(width: context.r(6)),
          Text(
            label,
            style: TextStyle(
              fontSize: context.rf(13),
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
