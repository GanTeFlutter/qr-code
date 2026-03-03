import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';

class TextQrForm extends StatelessWidget {
  const TextQrForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  Widget build(BuildContext context) {
    return QrFormField(
      label: LocaleKeys.create_qr_fields_text.tr(),
      icon: Icons.edit_note_rounded,
      maxLines: 5,
      initialValue: initialData?['text'],
      onChanged: (v) =>
          context.read<CreateQrCubit>().updateFormField('text', v),
    );
  }
}
