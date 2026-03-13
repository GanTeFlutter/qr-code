import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/state/scanner_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/state/scanner_state.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/widget/scan_result_sheet.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/widget/scanner_overlay.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  MobileScannerController? _controller;
  bool _isFlashOn = false;
  bool _sheetShown = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _controller = MobileScannerController();
      if (mounted) setState(() {});
    } on MobileScannerException catch (e) {
      _handleCameraError(e.errorCode.name);
    } on PlatformException catch (e) {
      _handleCameraError(e.message ?? 'Kamera baslatilamadi');
    }
  }

  void _handleCameraError(String message) {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleKeys.scanner_title.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Flas toggle
          IconButton(
            onPressed: _hasError ? null : _toggleFlash,
            icon: Icon(
              _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: Colors.white,
            ),
            tooltip: _isFlashOn
                ? LocaleKeys.scanner_flash_off.tr()
                : LocaleKeys.scanner_flash_on.tr(),
          ),
          // Kamera gecisi
          IconButton(
            onPressed: _hasError ? null : () => _controller?.switchCamera(const ToggleLensType()),
            icon: const Icon(
              Icons.cameraswitch_rounded,
              color: Colors.white,
            ),
          ),
          // Galeriden sec
          IconButton(
            onPressed: _pickFromGallery,
            icon: const Icon(
              Icons.photo_library_rounded,
              color: Colors.white,
            ),
            tooltip: LocaleKeys.scanner_gallery.tr(),
          ),
        ],
      ),
      body: BlocListener<ScannerCubit, ScannerState>(
        listener: _onStateChanged,
        child: _hasError ? _buildErrorView(colorScheme) : _buildCameraView(colorScheme),
      ),
    );
  }

  Widget _buildCameraView(ColorScheme colorScheme) {
    final controller = _controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Kamera
        MobileScanner(
          controller: controller,
          errorBuilder: (_, error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleCameraError(error.errorCode.name);
            });
            return const SizedBox.shrink();
          },
          onDetect: _onDetect,
        ),

        // Overlay
        const ScannerOverlay(),

        // Kose cizgileri
        CustomPaint(
          size: MediaQuery.sizeOf(context),
          painter: ScannerCornersPainter(color: colorScheme.primary),
        ),

        // Tarama ipucu
        Positioned(
          bottom: MediaQuery.paddingOf(context).bottom + 120,
          left: 0,
          right: 0,
          child: Text(
            LocaleKeys.scanner_scan_hint.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(ColorScheme colorScheme) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.no_photography_rounded,
                size: 64,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.scanner_camera_permission_title.tr(),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : LocaleKeys.scanner_camera_permission_message.tr(),
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Galeriden QR tara butonu (kamera olmasa bile calisir)
              FilledButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library_rounded),
                label: Text(LocaleKeys.scanner_gallery.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final value = barcodes.first.rawValue;
    if (value == null || value.isEmpty) return;

    context.read<ScannerCubit>().onBarcodeDetected(value);
  }

  void _onStateChanged(BuildContext context, ScannerState state) {
    if (state.status == ScannerStatus.scanned && !_sheetShown) {
      _sheetShown = true;

      // Haptic + ses
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);

      // Kamerayi duraklat
      _controller?.stop();

      _showResultSheet(context, state);
    }
  }

  void _showResultSheet(BuildContext context, ScannerState state) {
    final cubit = context.read<ScannerCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => ScanResultSheet(
        content: state.scannedContent,
        type: state.detectedType,
        onScanAgain: () {
          Navigator.of(context).pop();
        },
      ),
    ).then((_) {
      _sheetShown = false;
      if (!mounted) return;
      cubit.reset();
      _controller?.start();
    });
  }

  Future<void> _toggleFlash() async {
    await _controller?.toggleTorch();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final controller = _controller;
    if (controller == null) {
      // Kamera yoksa bile galeriden analiz icin gecici controller
      final tempController = MobileScannerController();
      try {
        final result = await tempController.analyzeImage(image.path);
        if (result != null && result.barcodes.isNotEmpty) {
          final value = result.barcodes.first.rawValue;
          if (value != null && value.isNotEmpty && mounted) {
            context.read<ScannerCubit>().onBarcodeDetected(value);
          }
        } else {
          _showNoQrFoundSnackBar();
        }
      } on PlatformException {
        _showNoQrFoundSnackBar();
      } finally {
        await tempController.dispose();
      }
      return;
    }

    try {
      final result = await controller.analyzeImage(image.path);
      if (result != null && result.barcodes.isNotEmpty) {
        final value = result.barcodes.first.rawValue;
        if (value != null && value.isNotEmpty && mounted) {
          context.read<ScannerCubit>().onBarcodeDetected(value);
        } else {
          _showNoQrFoundSnackBar();
        }
      } else {
        _showNoQrFoundSnackBar();
      }
    } on PlatformException {
      _showNoQrFoundSnackBar();
    }
  }

  void _showNoQrFoundSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(LocaleKeys.scanner_no_qr_found.tr())),
    );
  }
}
