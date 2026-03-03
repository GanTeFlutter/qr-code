import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/view/qr_preview_view.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/app_store_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/crypto_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/email_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/location_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/phone_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/sms_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/social_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/text_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/url_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/vcard_form.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_fields/wifi_form.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/navigation/route_transitions.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class QrFormView extends StatelessWidget {
  const QrFormView({required this.type, this.initialData, super.key});

  final QrType type;
  final Map<String, String>? initialData;

  String _titleForType() {
    return switch (type) {
      QrType.url => LocaleKeys.create_qr_types_url.tr(),
      QrType.text => LocaleKeys.create_qr_types_text.tr(),
      QrType.wifi => LocaleKeys.create_qr_types_wifi.tr(),
      QrType.phone => LocaleKeys.create_qr_types_phone.tr(),
      QrType.sms => LocaleKeys.create_qr_types_sms.tr(),
      QrType.email => LocaleKeys.create_qr_types_email.tr(),
      QrType.vcard => LocaleKeys.create_qr_types_vcard.tr(),
      QrType.location => LocaleKeys.create_qr_types_location.tr(),
      QrType.social => LocaleKeys.create_qr_types_social.tr(),
      QrType.appStore => LocaleKeys.create_qr_types_appStore.tr(),
      QrType.crypto => LocaleKeys.create_qr_types_crypto.tr(),
    };
  }

  String _helpForType() {
    return switch (type) {
      QrType.url => LocaleKeys.create_qr_help_url.tr(),
      QrType.text => LocaleKeys.create_qr_help_text.tr(),
      QrType.wifi => LocaleKeys.create_qr_help_wifi.tr(),
      QrType.phone => LocaleKeys.create_qr_help_phone.tr(),
      QrType.sms => LocaleKeys.create_qr_help_sms.tr(),
      QrType.email => LocaleKeys.create_qr_help_email.tr(),
      QrType.vcard => LocaleKeys.create_qr_help_vcard.tr(),
      QrType.location => LocaleKeys.create_qr_help_location.tr(),
      QrType.social => LocaleKeys.create_qr_help_social.tr(),
      QrType.appStore => LocaleKeys.create_qr_help_appStore.tr(),
      QrType.crypto => LocaleKeys.create_qr_help_crypto.tr(),
    };
  }

  void _showHelpDialog(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(type.icon, color: cs.primary, size: 32),
        title: Text(LocaleKeys.create_qr_help_title.tr()),
        content: Text(
          _helpForType(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.general_ok.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final data = initialData;
    return switch (type) {
      QrType.url => UrlForm(initialData: data),
      QrType.text => TextQrForm(initialData: data),
      QrType.wifi => WifiForm(initialData: data),
      QrType.phone => PhoneForm(initialData: data),
      QrType.sms => SmsForm(initialData: data),
      QrType.email => EmailForm(initialData: data),
      QrType.vcard => VcardForm(initialData: data),
      QrType.location => LocationForm(initialData: data),
      QrType.social => SocialForm(initialData: data),
      QrType.appStore => AppStoreForm(initialData: data),
      QrType.crypto => CryptoForm(initialData: data),
    };
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon, color: cs.primary, size: context.r(22)),
            SizedBox(width: context.r(8)),
            Text(_titleForType()),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showHelpDialog(context),
            icon: Icon(
              Icons.info_outline_rounded,
              color: cs.primary,
            ),
            tooltip: LocaleKeys.create_qr_help_title.tr(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.r(20)),
              child: _buildForm(),
            ),
          ),
          // ── Alt buton ─────────────────────────────────────────
          BlocBuilder<CreateQrCubit, CreateQrState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  context.r(20),
                  context.r(8),
                  context.r(20),
                  context.r(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.isFormValid
                        ? () {
                            context.read<CreateQrCubit>().generateQrContent();
                            Navigator.of(context).push(
                              slideRightRoute<void>(
                                BlocProvider.value(
                                  value: context.read<CreateQrCubit>(),
                                  child: const QrPreviewView(),
                                ),
                              ),
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      disabledBackgroundColor: cs.onSurface.withValues(
                        alpha: 0.12,
                      ),
                      padding: EdgeInsets.symmetric(vertical: context.r(16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.r(16)),
                      ),
                    ),
                    child: Text(
                      '${LocaleKeys.create_qr_generate_button.tr()} →',
                      style: TextStyle(
                        fontSize: context.rf(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
