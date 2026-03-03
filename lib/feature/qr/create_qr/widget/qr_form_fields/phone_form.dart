import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';

class PhoneForm extends StatelessWidget {
  const PhoneForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  Widget build(BuildContext context) {
    final v = FieldValidators.phone();
    return BlocSelector<CreateQrCubit, CreateQrState, String?>(
      selector: (state) => state.validationErrors['phone'],
      builder: (context, error) => QrFormField(
        label: LocaleKeys.create_qr_fields_phone_number.tr(),
        icon: Icons.phone_rounded,
        hint: '+905551234567',
        keyboardType: TextInputType.phone,
        initialValue: initialData?['phone'],
        inputFormatters: v.formatters,
        errorText: error?.tr(),
        onChanged: (v) =>
            context.read<CreateQrCubit>().updateFormField('phone', v),
      ),
    );
  }
}
