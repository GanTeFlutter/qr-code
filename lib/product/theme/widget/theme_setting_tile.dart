import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/product/init/language/locale_keys.g.dart';
import 'package:qrcode_akillisletme/product/theme/state/theme/theme_cubit.dart';
import 'package:qrcode_akillisletme/product/theme/widget/theme_selection_dialog.dart';

/// Uygulama tema secim tile'i.
class ThemeSettingTile extends StatelessWidget {
  const ThemeSettingTile({super.key});

  String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => LocaleKeys.theme_light.tr(),
      ThemeMode.dark => LocaleKeys.theme_dark.tr(),
      ThemeMode.system => LocaleKeys.theme_system.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final themeState = context.watch<ThemeCubit>().state;

    return ListTile(
      leading: Icon(Icons.palette_rounded, color: themeState.variant.previewColor),
      title: Text(LocaleKeys.theme_appTheme.tr()),
      trailing: Text(
        '${themeState.variant.localeKey.tr()} · ${_themeModeLabel(themeState.themeMode)}',
        style: TextStyle(color: cs.onSurfaceVariant),
      ),
      onTap: () => ThemeSelectionDialog.show(context),
    );
  }
}
