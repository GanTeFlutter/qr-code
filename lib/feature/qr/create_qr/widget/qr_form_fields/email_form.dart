import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class EmailForm extends StatelessWidget {
  const EmailForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<CreateQrCubit, CreateQrState, String?>(
          selector: (state) => state.validationErrors['email'],
          builder: (context, error) => QrFormField(
            label: LocaleKeys.create_qr_fields_email_address.tr(),
            icon: Icons.email_outlined,
            hint: 'test@mail.com',
            keyboardType: TextInputType.emailAddress,
            initialValue: initialData?['email'],
            inputFormatters: FieldValidators.email().formatters,
            errorText: error?.tr(),
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('email', v),
          ),
        ),
        SizedBox(height: context.r(16)),
        QrFormField(
          label: LocaleKeys.create_qr_fields_subject.tr(),
          icon: Icons.subject_rounded,
          initialValue: initialData?['subject'],
          onChanged: (v) =>
              context.read<CreateQrCubit>().updateFormField('subject', v),
        ),
        SizedBox(height: context.r(16)),
        QrFormField(
          label: LocaleKeys.create_qr_fields_message.tr(),
          icon: Icons.edit_note_rounded,
          maxLines: 3,
          initialValue: initialData?['message'],
          onChanged: (v) =>
              context.read<CreateQrCubit>().updateFormField('message', v),
        ),
      ],
    );
  }
}
