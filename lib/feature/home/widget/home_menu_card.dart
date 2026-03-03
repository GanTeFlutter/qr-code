import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class HomeMenuCard extends StatelessWidget {
  const HomeMenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.isHero = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool isHero;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(context.r(16)),
      elevation: isHero ? 4 : 2,
      shadowColor: cs.shadow.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.r(16)),
        child: Container(
          padding: EdgeInsets.all(context.r(isHero ? 24 : 16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(16)),
            border: Border.all(
              color: isHero
                  ? cs.primary.withValues(alpha: 0.3)
                  : cs.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: isHero ? _buildHeroContent(cs, textTheme, context) : _buildGridContent(cs, textTheme, context),
        ),
      ),
    );
  }

  Widget _buildHeroContent(ColorScheme cs, TextTheme textTheme, BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(context.r(16)),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
          child: Icon(
            icon,
            size: context.r(40),
            color: cs.primary,
          ),
        ),
        SizedBox(width: context.r(16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: context.rf(20),
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: context.r(4)),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: context.rf(13),
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: context.r(18),
          color: cs.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildGridContent(ColorScheme cs, TextTheme textTheme, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(context.r(8)),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(context.r(10)),
          ),
          child: Icon(
            icon,
            size: context.r(24),
            color: cs.primary,
          ),
        ),
        SizedBox(height: context.r(8)),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontSize: context.rf(13),
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
