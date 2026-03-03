import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/service/qr_svg_exporter.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_preview_widget.dart';
import 'package:qrcode_akillisletme/feature/qr/history/service/history_service.dart';
import 'package:qrcode_akillisletme/product/enum/history_source.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';
import 'package:qrcode_akillisletme/product/widget/app_outlined_icon_button.dart';
import 'package:share_plus/share_plus.dart';

class QrPreviewView extends StatefulWidget {
  const QrPreviewView({super.key});

  @override
  State<QrPreviewView> createState() => _QrPreviewViewState();
}

class _QrPreviewViewState extends State<QrPreviewView> {
  final _repaintKey = GlobalKey();

  // ── Preset renkler ─────────────────────────────────────────
  static const _fgColors = [
    Color(0xFF1A1A2E),
    Color(0xFF6C5CE7),
    Color(0xFF0984E3),
    Color(0xFF00B894),
    Color(0xFFE17055),
    Color(0xFFE84393),
    Color(0xFF2D3436),
    Color(0xFFD63031),
  ];

  static const _bgColors = [
    Color(0xFFFFFFFF),
    Color(0xFFF0F0F0),
    Color(0xFF1A1A2E),
    Color(0xFFFFF3E0),
  ];

  Future<File> _exportPng() async {
    final boundary =
        _repaintKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _save() async {
    final state = context.read<CreateQrCubit>().state;
    try {
      final file = await _exportPng();
      await Gal.putImage(file.path);
      await HapticFeedback.mediumImpact();

      // Gecmise kaydet
      final type = state.selectedType ?? QrType.text;
      HistoryService().addToHistory(
        content: state.qrContent,
        qrType: type,
        source: HistorySource.created,
        title: _titleForContent(type, state.formData),
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

  String _titleForContent(QrType type, Map<String, String> formData) {
    switch (type) {
      case QrType.url:
        return formData['url'] ?? '';
      case QrType.text:
        final text = formData['text'] ?? '';
        return text.length > 50 ? text.substring(0, 50) : text;
      case QrType.wifi:
        return formData['ssid'] ?? '';
      case QrType.phone:
        return formData['phone'] ?? '';
      case QrType.sms:
        return formData['phone'] ?? '';
      case QrType.email:
        return formData['email'] ?? '';
      case QrType.vcard:
        return formData['name'] ?? '';
      case QrType.location:
        final lat = formData['latitude'] ?? '';
        final lng = formData['longitude'] ?? '';
        return '$lat, $lng';
      case QrType.social:
        final platform = formData['platform'] ?? 'instagram';
        final username = formData['username'] ?? '';
        return '$platform: $username';
      case QrType.appStore:
        return formData['store_url'] ?? '';
      case QrType.crypto:
        final coin = formData['coin'] ?? 'bitcoin';
        final address = formData['address'] ?? '';
        return '$coin: $address';
    }
  }

  Future<void> _share() async {
    try {
      final file = await _exportPng();
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } on Exception {
      // Ignore share cancel
    }
  }

  Future<void> _saveSvg() async {
    final state = context.read<CreateQrCubit>().state;
    try {
      final svgString = QrSvgExporter().generate(
        qrData: state.qrContent,
        fgColor: state.fgColor,
        bgColor: state.bgColor,
        dotStyle: state.dotStyle,
        frameStyle: state.frameStyle,
        centerLogo: state.centerLogo,
      );

      final fileName = 'qr_${DateTime.now().millisecondsSinceEpoch}.svg';

      if (Platform.isAndroid) {
        Directory? svgDir;
        try {
          svgDir = Directory('/storage/emulated/0/Download/QR Codes');
          if (!svgDir.existsSync()) svgDir.createSync();
        } on FileSystemException {
          final extDir = await getExternalStorageDirectory();
          if (extDir != null) {
            svgDir = Directory('${extDir.path}/QR Codes');
            if (!svgDir.existsSync()) svgDir.createSync();
          }
        }

        if (svgDir != null) {
          final nomedia = File('${svgDir.path}/.nomedia');
          if (!nomedia.existsSync()) nomedia.createSync();

          final file = File('${svgDir.path}/$fileName');
          await file.writeAsString(svgString);
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final svgDir = Directory('${dir.path}/QR Codes');
        if (!svgDir.existsSync()) svgDir.createSync();
        final file = File('${svgDir.path}/$fileName');
        await file.writeAsString(svgString);
      }

      await HapticFeedback.mediumImpact();
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
    context.locale;
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
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.r(16),
                          vertical: context.r(14),
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
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
                                borderRadius: BorderRadius.circular(
                                  context.r(11),
                                ),
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
                                state.qrContent,
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
                                Clipboard.setData(
                                  ClipboardData(text: state.qrContent),
                                );
                                HapticFeedback.lightImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      LocaleKeys.create_qr_copied.tr(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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
                      onPressed: () => _showCustomizeSheet(context, cubit),
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

  // ── Ozellestirme bottom sheet ────────────────────────────────
  void _showCustomizeSheet(BuildContext context, CreateQrCubit cubit) {
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
                    _buildSectionLabel(
                      context,
                      LocaleKeys.create_qr_frame_style.tr(),
                    ),
                    SizedBox(height: context.r(8)),
                    _buildFrameSelector(context, state, cubit, cs),
                    SizedBox(height: context.r(16)),

                    // ── Logo ───────────────────────────────
                    _buildSectionLabel(context, LocaleKeys.create_qr_logo.tr()),
                    SizedBox(height: context.r(8)),
                    _buildLogoSection(context, state, cubit, cs),
                    SizedBox(height: context.r(16)),

                    // ── Nokta stili ────────────────────────
                    _buildSectionLabel(
                      context,
                      LocaleKeys.create_qr_dot_style.tr(),
                    ),
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
                    _buildSectionLabel(
                      context,
                      LocaleKeys.create_qr_qr_color.tr(),
                    ),
                    SizedBox(height: context.r(8)),
                    _buildColorRow(
                      context,
                      colors: _fgColors,
                      selected: state.fgColor,
                      onSelect: cubit.updateFgColor,
                    ),
                    SizedBox(height: context.r(16)),

                    // ── Arka plan rengi ────────────────────
                    _buildSectionLabel(
                      context,
                      LocaleKeys.create_qr_bg_color.tr(),
                    ),
                    SizedBox(height: context.r(8)),
                    _buildColorRow(
                      context,
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

  // ── Cerceve secici ──────────────────────────────────────────
  Widget _buildFrameSelector(
    BuildContext context,
    CreateQrState state,
    CreateQrCubit cubit,
    ColorScheme cs,
  ) {
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
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
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

  // ── Logo bolumu ────────────────────────────────────────────
  Widget _buildLogoSection(
    BuildContext context,
    CreateQrState state,
    CreateQrCubit cubit,
    ColorScheme cs,
  ) {
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
      onPressed: () => _pickAndCropLogo(cubit),
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

  Future<void> _pickAndCropLogo(CreateQrCubit cubit) async {
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
        debugPrint('[CreateQR] Logo cok buyuk: ${bytes.lengthInBytes} bytes');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.create_qr_save_error.tr())),
          );
        }
        return;
      }

      debugPrint('[CreateQR] Logo secildi: ${bytes.lengthInBytes} bytes');
      cubit.setCenterLogo(bytes);
    } on Exception catch (e, stack) {
      debugPrint('[CreateQR] Logo secme hatasi: $e');
      debugPrint('[CreateQR] Stack: $stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.create_qr_save_error.tr())),
        );
      }
    }
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: context.rf(12),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildColorRow(
    BuildContext context, {
    required List<Color> colors,
    required Color selected,
    required ValueChanged<Color> onSelect,
  }) {
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
                    : Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
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
