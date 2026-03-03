import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class VcardForm extends StatelessWidget {
  const VcardForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  Widget build(BuildContext context) {
    final phoneV = FieldValidators.phone();
    return BlocSelector<CreateQrCubit, CreateQrState, Map<String, String>>(
      selector: (state) => state.validationErrors,
      builder: (context, errors) => Column(
        children: [
          QrFormField(
            label: LocaleKeys.create_qr_fields_full_name.tr(),
            icon: Icons.person_outline_rounded,
            initialValue: initialData?['name'],
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('name', v),
          ),
          SizedBox(height: context.r(16)),
          QrFormField(
            label: LocaleKeys.create_qr_fields_phone_number.tr(),
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            initialValue: initialData?['phone'],
            inputFormatters: phoneV.formatters,
            errorText: errors['phone']?.tr(),
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('phone', v),
          ),
          SizedBox(height: context.r(16)),
          QrFormField(
            label: LocaleKeys.create_qr_fields_email_address.tr(),
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            initialValue: initialData?['email'],
            inputFormatters: FieldValidators.email().formatters,
            errorText: errors['email']?.tr(),
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('email', v),
          ),
          SizedBox(height: context.r(16)),
          QrFormField(
            label: LocaleKeys.create_qr_fields_company.tr(),
            icon: Icons.business_rounded,
            initialValue: initialData?['company'],
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('company', v),
          ),
        ],
      ),
    );
  }
}
