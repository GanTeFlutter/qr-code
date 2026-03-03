import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// QR tur secim karti — 2 sutunlu grid icinde kullanilir.
class QrTypeCard extends StatelessWidget {
  const QrTypeCard({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final QrType type;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(context.r(18)),
      elevation: 2,
      shadowColor: cs.shadow.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.r(18)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.r(20),
            horizontal: context.r(16),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(18)),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.r(44),
                height: context.r(44),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(context.r(13)),
                ),
                child: Center(
                  child: Icon(
                    type.icon,
                    size: context.r(24),
                    color: cs.primary,
                  ),
                ),
              ),
              SizedBox(height: context.r(12)),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontSize: context.rf(15),
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.r(4)),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: context.rf(12),
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
