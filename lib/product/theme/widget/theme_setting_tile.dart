import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/product/theme/state/theme/theme_cubit.dart';
import 'package:qrcode_akillisletme/product/theme/widget/theme_selection_dialog.dart';

/// Uygulama tema secim tile'i.
class ThemeSettingTile extends StatelessWidget {
  const ThemeSettingTile({super.key});

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final themeState = context.watch<ThemeCubit>().state;

    return ListTile(
      leading: Icon(Icons.palette_rounded, color: themeState.variant.previewColor),
      title: const Text('App Theme'),
      trailing: Text(
        '${themeState.variant.label} · ${_themeModeLabel(themeState.themeMode)}',
        style: TextStyle(color: cs.onSurfaceVariant),
      ),
      onTap: () => ThemeSelectionDialog.show(context),
    );
  }
}
