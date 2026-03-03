import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/service/qr_content_parser.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';

class CreateQrCubit extends Cubit<CreateQrState> {
  CreateQrCubit() : super(const CreateQrState());

  void loadFromHistory({required String content, required String qrTypeName}) {
    final type = QrType.values.where((e) => e.name == qrTypeName).firstOrNull;
    if (type == null) return;
    final formData = QrContentParser.parse(content, qrTypeName);
    final errors = _collectErrors(type, formData);
    emit(
      CreateQrState(
        selectedType: type,
        formData: formData,
        validationErrors: errors,
        isFormValid: _validate(type, formData, errors),
      ),
    );
  }

  void selectType(QrType type) {
    emit(const CreateQrState().copyWith(selectedType: type));
  }

  void updateFormField(String key, String value) {
    final updated = Map<String, String>.from(state.formData)..[key] = value;
    final errors = _collectErrors(state.selectedType, updated);
    emit(
      state.copyWith(
        formData: updated,
        validationErrors: errors,
        isFormValid: _validate(state.selectedType, updated, errors),
      ),
    );
  }

  void generateQrContent() {
    final type = state.selectedType;
    if (type == null) return;

    final data = state.formData;
    final content = switch (type) {
      QrType.url => data['url'] ?? '',
      QrType.text => data['text'] ?? '',
      QrType.wifi => _buildWifi(data),
      QrType.phone => 'tel:${data['phone'] ?? ''}',
      QrType.sms => 'smsto:${data['phone'] ?? ''}:${data['message'] ?? ''}',
      QrType.email => _buildEmail(data),
      QrType.vcard => _buildVCard(data),
      QrType.location =>
        'geo:${data['latitude'] ?? '0'},${data['longitude'] ?? '0'}',
      QrType.social => _buildSocialUrl(data),
      QrType.appStore => data['store_url'] ?? '',
      QrType.crypto => _buildCryptoUri(data),
    };

    emit(state.copyWith(qrContent: content, status: CreateQrStatus.generated));
  }

  void updateFgColor(Color color) => emit(state.copyWith(fgColor: color));

  void updateBgColor(Color color) => emit(state.copyWith(bgColor: color));

  void updateDotStyle(DotStyle style) => emit(state.copyWith(dotStyle: style));

  void updateFrameStyle(FrameStyle style) =>
      emit(state.copyWith(frameStyle: style));

  void setCenterLogo(Uint8List? logo) {
    if (logo == null) {
      emit(state.copyWith(clearLogo: true));
    } else {
      emit(state.copyWith(centerLogo: logo));
    }
  }

  void reset() => emit(const CreateQrState());

  // ── Private helpers ────────────────────────────────────────

  /// Her alan için FieldValidators ile format hatasını toplar.
  /// Boş alanlar henüz doğrulanmaz (kullanıcı henüz yazmamış olabilir).
  Map<String, String> _collectErrors(
    QrType? type,
    Map<String, String> data,
  ) {
    if (type == null) return const {};
    final errors = <String, String>{};

    void check(String key, FieldValidation validation) {
      final value = data[key] ?? '';
      if (value.isEmpty) return; // Boş alan → henüz hata gösterme
      final error = validation.validator(value);
      if (error != null) errors[key] = error;
    }

    switch (type) {
      case QrType.url:
        check('url', FieldValidators.url());
      case QrType.phone:
        check('phone', FieldValidators.phone());
      case QrType.sms:
        check('phone', FieldValidators.phone());
      case QrType.email:
        check('email', FieldValidators.email());
      case QrType.location:
        check('latitude', FieldValidators.latitude());
        check('longitude', FieldValidators.longitude());
      case QrType.social:
        check('username', FieldValidators.username());
      case QrType.appStore:
        check('store_url', FieldValidators.storeUrl());
      case QrType.crypto:
        check('address', FieldValidators.walletAddress());
        check('amount', FieldValidators.amount());
      case QrType.vcard:
        check('phone', FieldValidators.phone());
        check('email', FieldValidators.email());
      case QrType.text:
      case QrType.wifi:
        break; // Serbest metin — format doğrulama yok
    }
    return errors;
  }

  bool _validate(
    QrType? type,
    Map<String, String> data, [
    Map<String, String> errors = const {},
  ]) {
    if (type == null) return false;
    // Önce format hataları varsa geçersiz
    if (errors.isNotEmpty) return false;
    // Sonra zorunlu alanlar boş mu kontrol et
    return switch (type) {
      QrType.url => (data['url'] ?? '').isNotEmpty,
      QrType.text => (data['text'] ?? '').isNotEmpty,
      QrType.wifi => (data['ssid'] ?? '').isNotEmpty,
      QrType.phone => (data['phone'] ?? '').isNotEmpty,
      QrType.sms => (data['phone'] ?? '').isNotEmpty,
      QrType.email => (data['email'] ?? '').isNotEmpty,
      QrType.vcard => (data['name'] ?? '').isNotEmpty,
      QrType.location =>
        (data['latitude'] ?? '').isNotEmpty &&
            (data['longitude'] ?? '').isNotEmpty,
      QrType.social => (data['username'] ?? '').isNotEmpty,
      QrType.appStore => (data['store_url'] ?? '').isNotEmpty,
      QrType.crypto => (data['address'] ?? '').isNotEmpty,
    };
  }

  String _buildWifi(Map<String, String> data) {
    final ssid = data['ssid'] ?? '';
    final password = data['password'] ?? '';
    final encryption = data['encryption'] ?? 'WPA';
    final hidden = data['hidden'] == 'true';
    return 'WIFI:T:$encryption;S:$ssid;P:$password;H:$hidden;;';
  }

  String _buildEmail(Map<String, String> data) {
    final email = data['email'] ?? '';
    final subject = data['subject'] ?? '';
    final body = data['message'] ?? '';
    return 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
  }

  String _buildVCard(Map<String, String> data) {
    final name = data['name'] ?? '';
    final phone = data['phone'] ?? '';
    final email = data['email'] ?? '';
    final company = data['company'] ?? '';
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCARD')
      ..writeln('VERSION:3.0')
      ..writeln('FN:$name');
    if (phone.isNotEmpty) buffer.writeln('TEL:$phone');
    if (email.isNotEmpty) buffer.writeln('EMAIL:$email');
    if (company.isNotEmpty) buffer.writeln('ORG:$company');
    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  static const _socialTemplates = {
    'instagram': 'https://instagram.com/{username}',
    'twitter': 'https://x.com/{username}',
    'facebook': 'https://facebook.com/{username}',
    'linkedin': 'https://linkedin.com/in/{username}',
    'tiktok': 'https://tiktok.com/@{username}',
    'youtube': 'https://youtube.com/@{username}',
  };

  String _buildSocialUrl(Map<String, String> data) {
    final platform = data['platform'] ?? 'instagram';
    final username = data['username'] ?? '';
    final template = _socialTemplates[platform] ?? _socialTemplates['instagram']!;
    return template.replaceAll('{username}', username);
  }

  String _buildCryptoUri(Map<String, String> data) {
    final coin = data['coin'] ?? 'bitcoin';
    final address = data['address'] ?? '';
    final amount = data['amount'] ?? '';
    final buffer = StringBuffer('$coin:$address');
    if (amount.isNotEmpty) {
      buffer.write('?amount=$amount');
    }
    return buffer.toString();
  }
}
