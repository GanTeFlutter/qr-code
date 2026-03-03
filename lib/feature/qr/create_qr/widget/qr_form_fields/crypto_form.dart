import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_state.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/widget/qr_form_field.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/utils/field_validators.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

class CryptoForm extends StatefulWidget {
  const CryptoForm({this.initialData, super.key});

  final Map<String, String>? initialData;

  @override
  State<CryptoForm> createState() => _CryptoFormState();
}

class _CryptoFormState extends State<CryptoForm> {
  late String _coin;

  static const _coins = [
    ('bitcoin', 'Bitcoin', Icons.currency_bitcoin_rounded),
    ('ethereum', 'Ethereum', Icons.diamond_outlined),
    ('litecoin', 'Litecoin', Icons.monetization_on_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _coin = widget.initialData?['coin'] ?? 'bitcoin';
    context.read<CreateQrCubit>().updateFormField('coin', _coin);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final walletV = FieldValidators.walletAddress();
    final amountV = FieldValidators.amount();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coin secici
        Text(
          LocaleKeys.create_qr_fields_coin.tr(),
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
          children: _coins.map((c) {
            final isSelected = _coin == c.$1;
            return ChoiceChip(
              avatar: Icon(c.$3, size: context.r(18)),
              label: Text(c.$2),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _coin = c.$1);
                context.read<CreateQrCubit>().updateFormField('coin', c.$1);
              },
            );
          }).toList(),
        ),
        SizedBox(height: context.r(16)),
        BlocSelector<CreateQrCubit, CreateQrState, Map<String, String>>(
          selector: (state) => state.validationErrors,
          builder: (context, errors) => Column(
            children: [
              QrFormField(
                label: LocaleKeys.create_qr_fields_wallet_address.tr(),
                icon: Icons.account_balance_wallet_outlined,
                hint: LocaleKeys.create_qr_fields_wallet_hint.tr(),
                initialValue: widget.initialData?['address'],
                inputFormatters: walletV.formatters,
                errorText: errors['address']?.tr(),
                onChanged: (v) => context
                    .read<CreateQrCubit>()
                    .updateFormField('address', v),
              ),
              SizedBox(height: context.r(16)),
              QrFormField(
                label: LocaleKeys.create_qr_fields_amount.tr(),
                icon: Icons.payments_outlined,
                hint: '0.00',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                initialValue: widget.initialData?['amount'],
                inputFormatters: amountV.formatters,
                errorText: errors['amount']?.tr(),
                onChanged: (v) => context
                    .read<CreateQrCubit>()
                    .updateFormField('amount', v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
