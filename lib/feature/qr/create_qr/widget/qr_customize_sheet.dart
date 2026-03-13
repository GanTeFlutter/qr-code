import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// QR kodu ozellestirme bottom sheet'ini gosterir.
void showQrCustomizeSheet(BuildContext context, CreateQrCubit cubit) {
  final cs = Theme.of(context).colorScheme;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: cs.surface,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.r(20)),
      ),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        minChildSize: 0.3,
        maxChildSize: 0.6,
        expand: false,
        builder: (context, scrollController) {
          return BlocBuilder<CreateQrCubit, CreateQrState>(
            bloc: cubit,
            builder: (context, state) {
              return ListView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  context.r(16),
                  0,
                  context.r(16),
                  context.r(20),
                ),
                children: [
                  // ── Handle bar ─────────────────────────
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: context.r(10)),
                      width: context.r(40),
                      height: context.r(4),
                      decoration: BoxDecoration(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: context.r(8)),

                  // ── Cerceve stili ──────────────────────
                  _SectionLabel(text: LocaleKeys.create_qr_frame_style.tr()),
                  SizedBox(height: context.r(8)),
                  _FrameSelector(state: state, cubit: cubit),
                  SizedBox(height: context.r(16)),

                  // ── Logo ───────────────────────────────
                  _SectionLabel(text: LocaleKeys.create_qr_logo.tr()),
                  SizedBox(height: context.r(8)),
                  _LogoSection(state: state, cubit: cubit),
                  SizedBox(height: context.r(16)),

                  // ── Nokta stili ────────────────────────
                  _SectionLabel(text: LocaleKeys.create_qr_dot_style.tr()),
                  SizedBox(height: context.r(8)),
                  SegmentedButton<DotStyle>(
                    segments: [
                      ButtonSegment(
                        value: DotStyle.square,
                        label: Text(LocaleKeys.create_qr_dot_square.tr()),
                      ),
                      ButtonSegment(
                        value: DotStyle.round,
                        label: Text(LocaleKeys.create_qr_dot_round.tr()),
                      ),
                      ButtonSegment(
                        value: DotStyle.dot,
                        label: Text(LocaleKeys.create_qr_dot_circle.tr()),
                      ),
                    ],
                    selected: {state.dotStyle},
                    onSelectionChanged: (v) => cubit.updateDotStyle(v.first),
                  ),
                  SizedBox(height: context.r(16)),

                  // ── QR rengi ───────────────────────────
                  _SectionLabel(text: LocaleKeys.create_qr_qr_color.tr()),
                  SizedBox(height: context.r(8)),
                  _ColorRow(
                    colors: _fgColors,
                    selected: state.fgColor,
                    onSelect: cubit.updateFgColor,
                  ),
                  SizedBox(height: context.r(16)),

                  // ── Arka plan rengi ────────────────────
                  _SectionLabel(text: LocaleKeys.create_qr_bg_color.tr()),
                  SizedBox(height: context.r(8)),
                  _ColorRow(
                    colors: _bgColors,
                    selected: state.bgColor,
                    onSelect: cubit.updateBgColor,
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

// ── Preset renkler ─────────────────────────────────────────
const _fgColors = [
  Color(0xFF1A1A2E),
  Color(0xFF6C5CE7),
  Color(0xFF0984E3),
  Color(0xFF00B894),
  Color(0xFFE17055),
  Color(0xFFE84393),
  Color(0xFF2D3436),
  Color(0xFFD63031),
];

const _bgColors = [
  Color(0xFFFFFFFF),
  Color(0xFFF0F0F0),
  Color(0xFF1A1A2E),
  Color(0xFFFFF3E0),
];

// ── Alt widget'lar ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: context.rf(12),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _FrameSelector extends StatelessWidget {
  const _FrameSelector({required this.state, required this.cubit});

  final CreateQrState state;
  final CreateQrCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const styles = FrameStyle.values;
    final labels = {
      FrameStyle.none: LocaleKeys.create_qr_frame_none.tr(),
      FrameStyle.solid: LocaleKeys.create_qr_frame_solid.tr(),
      FrameStyle.rounded: LocaleKeys.create_qr_frame_rounded.tr(),
      FrameStyle.dashed: LocaleKeys.create_qr_frame_dashed.tr(),
      FrameStyle.shadow: LocaleKeys.create_qr_frame_shadow.tr(),
      FrameStyle.elegant: LocaleKeys.create_qr_frame_elegant.tr(),
    };
    final icons = {
      FrameStyle.none: Icons.block_rounded,
      FrameStyle.solid: Icons.crop_square_rounded,
      FrameStyle.rounded: Icons.rounded_corner_rounded,
      FrameStyle.dashed: Icons.dashboard_customize_rounded,
      FrameStyle.shadow: Icons.layers_rounded,
      FrameStyle.elegant: Icons.auto_awesome_rounded,
    };

    return SizedBox(
      height: context.r(72),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        separatorBuilder: (_, __) => SizedBox(width: context.r(8)),
        itemBuilder: (context, index) {
          final style = styles[index];
          final isSelected = state.frameStyle == style;
          return GestureDetector(
            onTap: () => cubit.updateFrameStyle(style),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.r(72),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(
                  color: isSelected
                      ? cs.primary
                      : cs.outlineVariant.withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[style],
                    color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    size: context.r(22),
                  ),
                  SizedBox(height: context.r(4)),
                  Text(
                    labels[style]!,
                    style: TextStyle(
                      fontSize: context.rf(10),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection({required this.state, required this.cubit});

  final CreateQrState state;
  final CreateQrCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasLogo = state.centerLogo != null;

    if (hasLogo) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(10)),
            child: Image.memory(
              state.centerLogo!,
              width: context.r(48),
              height: context.r(48),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.r(12)),
          TextButton.icon(
            onPressed: () => cubit.setCenterLogo(null),
            icon: Icon(Icons.close_rounded, size: context.r(18)),
            label: Text(LocaleKeys.create_qr_remove_logo.tr()),
            style: TextButton.styleFrom(foregroundColor: cs.error),
          ),
        ],
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _pickAndCropLogo(context),
      icon: Icon(Icons.add_photo_alternate_rounded, size: context.r(20)),
      label: Text(LocaleKeys.create_qr_add_logo.tr()),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: context.r(16),
          vertical: context.r(10),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
    );
  }

  Future<void> _pickAndCropLogo(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (picked == null) return;

      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: LocaleKeys.create_qr_logo.tr(),
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: LocaleKeys.create_qr_logo.tr(),
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (cropped == null) return;

      final bytes = await File(cropped.path).readAsBytes();

      // Boyut kontrolu — 2MB'den buyuk resimleri reddet
      if (bytes.lengthInBytes > 2 * 1024 * 1024) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.create_qr_save_error.tr())),
          );
        }
        return;
      }

      cubit.setCenterLogo(bytes);
    } on Exception {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.create_qr_save_error.tr())),
        );
      }
    }
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({
    required this.colors,
    required this.selected,
    required this.onSelect,
  });

  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.r(10),
      runSpacing: context.r(10),
      children: colors.map((color) {
        final isSelected = color == selected;
        return GestureDetector(
          onTap: () => onSelect(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: context.r(34),
            height: context.r(34),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(context.r(10)),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withValues(alpha: 0.3),
                width: isSelected ? 2.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
