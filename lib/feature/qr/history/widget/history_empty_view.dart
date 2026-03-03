import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class HistoryEmptyView extends StatelessWidget {
  const HistoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.r(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: context.r(64),
              color: cs.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            SizedBox(height: context.r(16)),
            Text(
              LocaleKeys.history_empty_title.tr(),
              style: TextStyle(
                fontSize: context.rf(16),
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.r(8)),
            Text(
              LocaleKeys.history_empty_subtitle.tr(),
              style: TextStyle(
                fontSize: context.rf(13),
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
