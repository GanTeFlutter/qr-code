import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/model/qr_type.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/view/qr_form_view.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_type_card.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/navigation/route_transitions.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class CreateQrView extends StatelessWidget {
  const CreateQrView({super.key});

  String _labelForType(QrType type) {
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

  String _descForType(QrType type) {
    return switch (type) {
      QrType.url => LocaleKeys.create_qr_types_url_desc.tr(),
      QrType.text => LocaleKeys.create_qr_types_text_desc.tr(),
      QrType.wifi => LocaleKeys.create_qr_types_wifi_desc.tr(),
      QrType.phone => LocaleKeys.create_qr_types_phone_desc.tr(),
      QrType.sms => LocaleKeys.create_qr_types_sms_desc.tr(),
      QrType.email => LocaleKeys.create_qr_types_email_desc.tr(),
      QrType.vcard => LocaleKeys.create_qr_types_vcard_desc.tr(),
      QrType.location => LocaleKeys.create_qr_types_location_desc.tr(),
      QrType.social => LocaleKeys.create_qr_types_social_desc.tr(),
      QrType.appStore => LocaleKeys.create_qr_types_appStore_desc.tr(),
      QrType.crypto => LocaleKeys.create_qr_types_crypto_desc.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.create_qr_title.tr())),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Baslik + alt metin ──────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.r(20),
                context.r(16),
                context.r(20),
                context.r(12),
              ),
              child: Text(
                LocaleKeys.create_qr_subtitle.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: context.rf(14),
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),

            // ── QR tur kartlari grid ────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: context.r(20),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: context.r(12),
                  mainAxisSpacing: context.r(12),
                  childAspectRatio: 0.95,
                ),
                itemCount: QrType.values.length,
                itemBuilder: (context, index) {
                  final type = QrType.values[index];
                  return QrTypeCard(
                    type: type,
                    title: _labelForType(type),
                    subtitle: _descForType(type),
                    onTap: () {
                      context.read<CreateQrCubit>().selectType(type);
                      Navigator.of(context).push(
                        slideRightRoute<void>(
                          BlocProvider.value(
                            value: context.read<CreateQrCubit>(),
                            child: QrFormView(type: type),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
