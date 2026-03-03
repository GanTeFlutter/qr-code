import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/model/scan_result_type.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/service/smart_action_service.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/button_feedback.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// Tarama sonucu bottom sheet'i.
class ScanResultSheet extends StatelessWidget {
  const ScanResultSheet({
    required this.content,
    required this.type,
    required this.onScanAgain,
    super.key,
  });

  final String content;
  final ScanResultType type;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.r(24),
        context.r(8),
        context.r(24),
        context.r(24) + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(24)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: context.r(40),
            height: context.r(4),
            margin: EdgeInsets.only(bottom: context.r(16)),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(context.r(2)),
            ),
          ),

          // Baslik
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.r(10)),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(context.r(12)),
                ),
                child: Icon(
                  type.icon,
                  color: colorScheme.onPrimaryContainer,
                  size: context.r(24),
                ),
              ),
              SizedBox(width: context.r(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.scanner_result_title.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      type.labelKey.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.r(16)),

          // Icerik
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.r(14)),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(context.r(12)),
            ),
            child: SelectableText(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Inter',
              ),
              maxLines: 6,
            ),
          ),
          SizedBox(height: context.r(20)),

          // Birincil aksiyon butonu (tur bazli)
          if (_hasPrimaryAction) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ButtonFeedback.trigger();
                  SmartActionService.launchAction(type, content);
                },
                icon: Icon(_primaryActionIcon),
                label: Text(_primaryActionLabel(context)),
              ),
            ),
            SizedBox(height: context.r(10)),
          ],

          // Kopyala + Paylas satiri
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ButtonFeedback.trigger();
                    SmartActionService.copyToClipboard(content);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.create_qr_copied.tr()),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(LocaleKeys.scanner_copy.tr()),
                ),
              ),
              SizedBox(width: context.r(10)),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ButtonFeedback.trigger();
                    SmartActionService.shareContent(content);
                  },
                  icon: const Icon(Icons.share_rounded),
                  label: Text(LocaleKeys.scanner_share.tr()),
                ),
              ),
            ],
          ),
          SizedBox(height: context.r(10)),

          // Tekrar tara
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                ButtonFeedback.trigger();
                onScanAgain();
              },
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(LocaleKeys.scanner_scan_again.tr()),
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasPrimaryAction => switch (type) {
    ScanResultType.url ||
    ScanResultType.phone ||
    ScanResultType.email ||
    ScanResultType.sms ||
    ScanResultType.location ||
    ScanResultType.social ||
    ScanResultType.appStore => true,
    _ => false,
  };

  IconData get _primaryActionIcon => switch (type) {
    ScanResultType.url => Icons.open_in_browser_rounded,
    ScanResultType.phone => Icons.phone_rounded,
    ScanResultType.email => Icons.email_rounded,
    ScanResultType.sms => Icons.message_rounded,
    ScanResultType.location => Icons.map_rounded,
    ScanResultType.social => Icons.open_in_browser_rounded,
    ScanResultType.appStore => Icons.store_rounded,
    _ => Icons.open_in_new_rounded,
  };

  String _primaryActionLabel(BuildContext context) => switch (type) {
    ScanResultType.url => LocaleKeys.scanner_open_url.tr(),
    ScanResultType.phone => LocaleKeys.scanner_call.tr(),
    ScanResultType.email => LocaleKeys.scanner_send_email.tr(),
    ScanResultType.sms => LocaleKeys.scanner_send_sms.tr(),
    ScanResultType.location => LocaleKeys.scanner_show_on_map.tr(),
    ScanResultType.social => LocaleKeys.scanner_open_url.tr(),
    ScanResultType.appStore => LocaleKeys.scanner_open_url.tr(),
    _ => '',
  };
}
