import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/service/qr_export_service.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_customize_sheet.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_preview_widget.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';
import 'package:qrcode_akillisletme/product/widget/app_outlined_icon_button.dart';

class QrPreviewView extends StatefulWidget {
  const QrPreviewView({super.key});

  @override
  State<QrPreviewView> createState() => _QrPreviewViewState();
}

class _QrPreviewViewState extends State<QrPreviewView> {
  final _repaintKey = GlobalKey();

  Future<void> _save() async {
    final state = context.read<CreateQrCubit>().state;
    try {
      await QrExportService.saveToGallery(
        repaintKey: _repaintKey,
        state: state,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.create_qr_saved_to_gallery.tr())),
        );
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.create_qr_save_error.tr())),
        );
      }
    }
  }

  Future<void> _share() async {
    try {
      await QrExportService.share(_repaintKey);
    } on Exception {
      // Ignore share cancel
    }
  }

  Future<void> _saveSvg() async {
    final state = context.read<CreateQrCubit>().state;
    try {
      await QrExportService.saveSvg(state);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.create_qr_svg_saved.tr())),
        );
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.create_qr_save_error.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.create_qr_preview_title.tr())),
      body: BlocBuilder<CreateQrCubit, CreateQrState>(
        builder: (context, state) {
          final type = state.selectedType ?? QrType.text;
          final cubit = context.read<CreateQrCubit>();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.r(20),
                    context.r(20),
                    context.r(20),
                    context.r(12),
                  ),
                  child: Column(
                    children: [
                      // ── QR onizleme karti ──────────────────
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.r(24)),
                          boxShadow: [
                            BoxShadow(
                              color: cs.shadow.withValues(alpha: 0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: QrPreviewWidget(
                          data: state.qrContent,
                          repaintKey: _repaintKey,
                          size: context.r(260),
                          fgColor: state.fgColor,
                          bgColor: state.bgColor,
                          dotStyle: state.dotStyle,
                          frameStyle: state.frameStyle,
                          centerLogo: state.centerLogo,
                        ),
                      ),

                      SizedBox(height: context.r(20)),

                      // ── Icerik bilgi karti ─────────────────
                      _ContentInfoCard(
                        type: type,
                        qrContent: state.qrContent,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Aksiyon butonlari ──────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.r(20),
                  vertical: context.r(20),
                ),
                child: Column(
                  spacing: context.r(4),
                  children: [
                    AppOutlinedIconButton(
                      label: LocaleKeys.create_qr_customize.tr(),
                      icon: Icons.palette_rounded,
                      onPressed: () =>
                          showQrCustomizeSheet(context, cubit),
                    ),
                    AppOutlinedIconButton(
                      label: LocaleKeys.create_qr_fields_save_svg.tr(),
                      icon: Icons.code_rounded,
                      onPressed: _saveSvg,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppOutlinedIconButton(
                            label: LocaleKeys.create_qr_save.tr(),
                            icon: Icons.save_alt_rounded,
                            onPressed: _save,
                          ),
                        ),
                        SizedBox(width: context.r(10)),
                        Expanded(
                          child: AppOutlinedIconButton(
                            label: LocaleKeys.create_qr_share.tr(),
                            icon: Icons.share_rounded,
                            onPressed: _share,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Icerik bilgi karti — QR tipi ikonu + icerik metni + kopyala butonu.
class _ContentInfoCard extends StatelessWidget {
  const _ContentInfoCard({required this.type, required this.qrContent});

  final QrType type;
  final String qrContent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.r(16),
        vertical: context.r(14),
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: context.r(38),
            height: context.r(38),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(context.r(11)),
            ),
            child: Icon(
              type.icon,
              color: cs.primary,
              size: context.r(20),
            ),
          ),
          SizedBox(width: context.r(12)),
          Expanded(
            child: Text(
              qrContent,
              style: TextStyle(
                fontSize: context.rf(12),
                color: cs.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy_rounded,
              color: cs.onSurfaceVariant,
              size: context.r(20),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: qrContent));
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.create_qr_copied.tr()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
