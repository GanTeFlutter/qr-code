import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/history/service/history_service.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/model/scan_result_type.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/state/scanner_state.dart';
import 'package:qrcode_akillisletme/product/enum/history_source.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(const ScannerState());

  final _historyService = HistoryService();

  /// Barkod/QR tespit edildiginde cagirilir.
  void onBarcodeDetected(String content) {
    if (state.isPaused) return;
    if (content.isEmpty) return;

    final type = ScanResultType.detect(content);

    // Gecmise kaydet
    _historyService.addToHistory(
      content: content,
      qrType: type.toQrType(),
      source: HistorySource.scanned,
      title: _generateTitle(type, content),
    );

    emit(
      state.copyWith(
        status: ScannerStatus.scanned,
        scannedContent: content,
        detectedType: type,
        isPaused: true,
      ),
    );
  }

  /// Yeni tarama icin sifirla.
  void reset() {
    emit(const ScannerState());
  }

  /// Tarama duraklatma toggle.
  void togglePause() {
    emit(state.copyWith(isPaused: !state.isPaused));
  }

  String _generateTitle(ScanResultType type, String content) {
    return switch (type) {
      ScanResultType.url => Uri.tryParse(content)?.host ?? content,
      ScanResultType.wifi => _extractWifiSsid(content),
      ScanResultType.phone =>
        content.replaceFirst(RegExp('^tel:', caseSensitive: false), ''),
      ScanResultType.email =>
        content.replaceFirst(RegExp('^mailto:', caseSensitive: false), ''),
      ScanResultType.vcard => _extractVcardName(content),
      _ =>
        content.length > 50 ? '${content.substring(0, 50)}...' : content,
    };
  }

  String _extractWifiSsid(String content) {
    final match = RegExp('S:([^;]+)').firstMatch(content);
    return match?.group(1) ?? content;
  }

  String _extractVcardName(String content) {
    final match = RegExp('FN:(.+)').firstMatch(content);
    return match?.group(1)?.trim() ?? content;
  }
}
