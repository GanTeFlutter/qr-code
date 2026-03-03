import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';

class UrlForm extends StatelessWidget {
  const UrlForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateQrCubit, CreateQrState, String?>(
      selector: (state) => state.validationErrors['url'],
      builder: (context, error) => QrFormField(
        label: LocaleKeys.create_qr_fields_url.tr(),
        icon: Icons.link_rounded,
        hint: 'https://example.com',
        keyboardType: TextInputType.url,
        initialValue: initialData?['url'],
        inputFormatters: FieldValidators.url().formatters,
        errorText: error?.tr(),
        onChanged: (v) =>
            context.read<CreateQrCubit>().updateFormField('url', v),
      ),
    );
  }
}
