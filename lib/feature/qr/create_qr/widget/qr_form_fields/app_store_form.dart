import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class AppStoreForm extends StatefulWidget {
  const AppStoreForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  State<AppStoreForm> createState() => _AppStoreFormState();
}

class _AppStoreFormState extends State<AppStoreForm> {
  late String _storePlatform;

  static const _stores = [
    ('appStore', 'App Store', Icons.apple_rounded),
    ('playStore', 'Google Play', Icons.shop_rounded),
    ('huawei', 'AppGallery', Icons.store_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _storePlatform = widget.initialData?['store_platform'] ?? 'appStore';
    context
        .read<CreateQrCubit>()
        .updateFormField('store_platform', _storePlatform);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Platform secici
        Text(
          LocaleKeys.create_qr_fields_store_platform.tr(),
          style: TextStyle(
            fontSize: context.rf(13),
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.r(8)),
        Wrap(
          spacing: context.r(8),
          runSpacing: context.r(8),
          children: _stores.map((s) {
            final isSelected = _storePlatform == s.$1;
            return ChoiceChip(
              avatar: Icon(s.$3, size: context.r(18)),
              label: Text(s.$2),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _storePlatform = s.$1);
                context
                    .read<CreateQrCubit>()
                    .updateFormField('store_platform', s.$1);
              },
            );
          }).toList(),
        ),
        SizedBox(height: context.r(16)),
        BlocSelector<CreateQrCubit, CreateQrState, String?>(
          selector: (state) => state.validationErrors['store_url'],
          builder: (context, error) => QrFormField(
            label: LocaleKeys.create_qr_fields_store_url.tr(),
            icon: Icons.link_rounded,
            hint: 'https://apps.apple.com/...',
            keyboardType: TextInputType.url,
            initialValue: widget.initialData?['store_url'],
            inputFormatters: FieldValidators.storeUrl().formatters,
            errorText: error?.tr(),
            onChanged: (v) => context
                .read<CreateQrCubit>()
                .updateFormField('store_url', v),
          ),
        ),
      ],
    );
  }
}
