import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/product/utils/button_feedback.dart';

/// Ikonlu outlined aksiyon butonu — OutlinedButton.icon tabanli.
/// "Kaydet, paylas, indir" gibi ikonlu ikincil aksiyonlar icin.
/// Style tamamen tema'dan gelir (OutlinedButtonThemeData).
class AppOutlinedIconButton extends StatelessWidget {
  const AppOutlinedIconButton({
    required this.label,
    required this.icon,
    super.key,
    this.onPressed,
    this.isExpanded = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isExpanded;

  VoidCallback? get _wrappedOnPressed => onPressed != null
      ? () {
          ButtonFeedback.trigger();
          onPressed!();
        }
      : null;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: _wrappedOnPressed,
      icon: Icon(icon),
      label: Text(label),
    );

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
