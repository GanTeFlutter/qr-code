import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';

enum DotStyle { square, round, dot }

enum FrameStyle { none, solid, rounded, dashed, shadow, elegant }

enum CreateQrStatus { idle, generating, generated, saving, saved, error }

class CreateQrState {
  const CreateQrState({
    this.selectedType,
    this.formData = const {},
    this.validationErrors = const {},
    this.qrContent = '',
    this.fgColor = const Color(0xFF1A1A2E),
    this.bgColor = const Color(0xFFFFFFFF),
    this.dotStyle = DotStyle.square,
    this.frameStyle = FrameStyle.none,
    this.centerLogo,
    this.isFormValid = false,
    this.status = CreateQrStatus.idle,
  });

  final QrType? selectedType;
  final Map<String, String> formData;
  final Map<String, String> validationErrors;
  final String qrContent;
  final Color fgColor;
  final Color bgColor;
  final DotStyle dotStyle;
  final FrameStyle frameStyle;
  final Uint8List? centerLogo;
  final bool isFormValid;
  final CreateQrStatus status;

  CreateQrState copyWith({
    QrType? selectedType,
    Map<String, String>? formData,
    Map<String, String>? validationErrors,
    String? qrContent,
    Color? fgColor,
    Color? bgColor,
    DotStyle? dotStyle,
    FrameStyle? frameStyle,
    Uint8List? centerLogo,
    bool clearLogo = false,
    bool? isFormValid,
    CreateQrStatus? status,
  }) {
    return CreateQrState(
      selectedType: selectedType ?? this.selectedType,
      formData: formData ?? this.formData,
      validationErrors: validationErrors ?? this.validationErrors,
      qrContent: qrContent ?? this.qrContent,
      fgColor: fgColor ?? this.fgColor,
      bgColor: bgColor ?? this.bgColor,
      dotStyle: dotStyle ?? this.dotStyle,
      frameStyle: frameStyle ?? this.frameStyle,
      centerLogo: clearLogo ? null : (centerLogo ?? this.centerLogo),
      isFormValid: isFormValid ?? this.isFormValid,
      status: status ?? this.status,
    );
  }
}
