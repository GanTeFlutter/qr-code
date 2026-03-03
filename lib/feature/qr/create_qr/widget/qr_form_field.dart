import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode_akillisletme/product/utils/responsive_extension.dart';

/// Ortak form alani widget'i — tum QR form tipleri bunu kullanir.
class QrFormField extends StatefulWidget {
  const QrFormField({
    required this.label,
    required this.icon,
    required this.onChanged,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.initialValue,
    this.inputFormatters,
    this.errorText,
    super.key,
  });

  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget? suffixIcon;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  @override
  State<QrFormField> createState() => _QrFormFieldState();
}

class _QrFormFieldState extends State<QrFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: context.rf(13),
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: context.r(8)),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(context.r(14)),
            border: Border.all(
              color: hasError
                  ? cs.error.withValues(alpha: 0.6)
                  : cs.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: Icon(
                widget.icon,
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                size: context.r(20),
              ),
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: context.r(14),
              ),
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: context.r(6)),
          Padding(
            padding: EdgeInsets.only(left: context.r(12)),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                fontSize: context.rf(11),
                color: cs.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
