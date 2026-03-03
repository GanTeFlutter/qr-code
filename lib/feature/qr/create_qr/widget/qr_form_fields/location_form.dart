import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class LocationForm extends StatelessWidget {
  const LocationForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  Widget build(BuildContext context) {
    final latV = FieldValidators.latitude();
    final lngV = FieldValidators.longitude();
    return BlocSelector<CreateQrCubit, CreateQrState, Map<String, String>>(
      selector: (state) => state.validationErrors,
      builder: (context, errors) => Column(
        children: [
          QrFormField(
            label: LocaleKeys.create_qr_fields_latitude.tr(),
            icon: Icons.location_on_outlined,
            hint: '41.0082',
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            initialValue: initialData?['latitude'],
            inputFormatters: latV.formatters,
            errorText: errors['latitude']?.tr(),
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('latitude', v),
          ),
          SizedBox(height: context.r(16)),
          QrFormField(
            label: LocaleKeys.create_qr_fields_longitude.tr(),
            icon: Icons.location_on_outlined,
            hint: '28.9784',
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            initialValue: initialData?['longitude'],
            inputFormatters: lngV.formatters,
            errorText: errors['longitude']?.tr(),
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('longitude', v),
          ),
        ],
      ),
    );
  }
}
