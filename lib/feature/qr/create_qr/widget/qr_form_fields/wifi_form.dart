import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class WifiForm extends StatefulWidget {
  const WifiForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  State<WifiForm> createState() => _WifiFormState();
}

class _WifiFormState extends State<WifiForm> {
  late String _encryption;
  late bool _hidden;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _encryption = widget.initialData?['encryption'] ?? 'WPA';
    _hidden = widget.initialData?['hidden'] == 'true';
    context.read<CreateQrCubit>().updateFormField('encryption', _encryption);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        QrFormField(
          label: LocaleKeys.create_qr_fields_ssid.tr(),
          icon: Icons.wifi_rounded,
          initialValue: widget.initialData?['ssid'],
          onChanged: (v) =>
              context.read<CreateQrCubit>().updateFormField('ssid', v),
        ),
        SizedBox(height: context.r(16)),
        QrFormField(
          label: LocaleKeys.create_qr_fields_password.tr(),
          icon: Icons.lock_outline_rounded,
          obscureText: _obscure,
          initialValue: widget.initialData?['password'],
          suffixIcon: IconButton(
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: cs.onSurfaceVariant,
              size: context.r(20),
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          onChanged: (v) =>
              context.read<CreateQrCubit>().updateFormField('password', v),
        ),
        SizedBox(height: context.r(16)),
        // Sifreleme secimi
        _buildLabel(LocaleKeys.create_qr_fields_encryption.tr()),
        SizedBox(height: context.r(8)),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'WPA', label: Text('WPA/WPA2')),
            ButtonSegment(value: 'WEP', label: Text('WEP')),
            ButtonSegment(value: 'nopass', label: Text('Open')),
          ],
          selected: {_encryption},
          onSelectionChanged: (v) {
            setState(() => _encryption = v.first);
            context
                .read<CreateQrCubit>()
                .updateFormField('encryption', v.first);
          },
        ),
        SizedBox(height: context.r(16)),
        // Gizli ag
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            LocaleKeys.create_qr_fields_hidden_network.tr(),
            style: TextStyle(
              fontSize: context.rf(14),
              color: cs.onSurfaceVariant,
            ),
          ),
          value: _hidden,
          onChanged: (v) {
            setState(() => _hidden = v);
            context
                .read<CreateQrCubit>()
                .updateFormField('hidden', v.toString());
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: context.rf(13),
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
