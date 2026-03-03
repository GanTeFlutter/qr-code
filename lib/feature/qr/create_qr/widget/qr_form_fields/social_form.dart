import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class SocialForm extends StatefulWidget {
  const SocialForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  State<SocialForm> createState() => _SocialFormState();
}

class _SocialFormState extends State<SocialForm> {
  late String _platform;

  static const _platforms = [
    ('instagram', 'Instagram', Icons.camera_alt_rounded),
    ('twitter', 'Twitter / X', Icons.alternate_email_rounded),
    ('facebook', 'Facebook', Icons.facebook_rounded),
    ('linkedin', 'LinkedIn', Icons.work_outline_rounded),
    ('tiktok', 'TikTok', Icons.music_note_rounded),
    ('youtube', 'YouTube', Icons.play_circle_outline_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _platform = widget.initialData?['platform'] ?? 'instagram';
    context.read<CreateQrCubit>().updateFormField('platform', _platform);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final usernameV = FieldValidators.username();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Platform secici
        Text(
          LocaleKeys.create_qr_fields_platform.tr(),
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
          children: _platforms.map((p) {
            final isSelected = _platform == p.$1;
            return ChoiceChip(
              avatar: Icon(p.$3, size: context.r(18)),
              label: Text(p.$2),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _platform = p.$1);
                context
                    .read<CreateQrCubit>()
                    .updateFormField('platform', p.$1);
              },
            );
          }).toList(),
        ),
        SizedBox(height: context.r(16)),
        BlocSelector<CreateQrCubit, CreateQrState, String?>(
          selector: (state) => state.validationErrors['username'],
          builder: (context, error) => QrFormField(
            label: LocaleKeys.create_qr_fields_username.tr(),
            icon: Icons.alternate_email_rounded,
            hint: LocaleKeys.create_qr_fields_username_hint.tr(),
            initialValue: widget.initialData?['username'],
            inputFormatters: usernameV.formatters,
            errorText: error?.tr(),
            onChanged: (v) =>
                context.read<CreateQrCubit>().updateFormField('username', v),
          ),
        ),
      ],
    );
  }
}
