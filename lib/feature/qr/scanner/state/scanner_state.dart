import 'package:qrcode_akillisletme/feature/qr/scanner/model/scan_result_type.dart';

enum ScannerStatus { idle, scanned }

class ScannerState {
  const ScannerState({
    this.status = ScannerStatus.idle,
    this.scannedContent = '',
    this.detectedType = ScanResultType.text,
    this.isPaused = false,
  });

  final ScannerStatus status;
  final String scannedContent;
  final ScanResultType detectedType;
  final bool isPaused;

  ScannerState copyWith({
    ScannerStatus? status,
    String? scannedContent,
    ScanResultType? detectedType,
    bool? isPaused,
  }) {
    return ScannerState(
      status: status ?? this.status,
      scannedContent: scannedContent ?? this.scannedContent,
      detectedType: detectedType ?? this.detectedType,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}
