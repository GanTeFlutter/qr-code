import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/product/theme/app_theme_colors.dart';
import 'package:qrcode_akillisletme/product/theme/app_theme_variant.dart';
import 'package:qrcode_akillisletme/product/theme/state/theme/theme_cubit.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class ThemeSelectionDialog extends StatelessWidget {
  const ThemeSelectionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ThemeCubit>(),
        child: const ThemeSelectionDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return AlertDialog(
      title: Text(
        'Choose Theme',
        style: TextStyle(fontSize: context.rf(22)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── ThemeMode secimi ──────────────────────────────
            _ThemeModeSelector(currentMode: themeState.themeMode),
            SizedBox(height: context.r(16)),

            // ── Variant secimi ────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: context.r(12),
                crossAxisSpacing: context.r(12),
                childAspectRatio: 0.85,
              ),
              itemCount: AppThemeVariant.values.length,
              itemBuilder: (context, index) {
                final variant = AppThemeVariant.values[index];
                final isSelected = variant == themeState.variant;
                return _VariantCard(
                  variant: variant,
                  isSelected: isSelected,
                  onTap: () {
                    context.read<ThemeCubit>().setVariant(variant);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Dark / Light / System secici
class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.currentMode});

  final ThemeMode currentMode;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_rounded),
          label: Text('Light'),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.settings_brightness_rounded),
          label: Text('System'),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_rounded),
          label: Text('Dark'),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (selected) {
        context.read<ThemeCubit>().setThemeMode(selected.first);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return cs.primaryContainer;
          }
          return cs.surfaceContainerHighest;
        }),
      ),
    );
  }
}

class _VariantCard extends StatelessWidget {
  const _VariantCard({
    required this.variant,
    required this.isSelected,
    required this.onTap,
  });

  final AppThemeVariant variant;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(context.r(14)),
          border: Border.all(
            color: isSelected ? variant.previewColor : appColors.transparent,
            width: 2.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: context.r(44),
                  height: context.r(44),
                  decoration: BoxDecoration(
                    color: variant.previewColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    color: appColors.pureWhite,
                    size: context.r(24),
                  ),
              ],
            ),
            SizedBox(height: context.r(8)),
            Text(
              variant.label,
              style: TextStyle(
                fontSize: context.rf(13),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? variant.previewColor : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
