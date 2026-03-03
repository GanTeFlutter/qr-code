import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/product/cache/shared_operation/shared_keys.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';
import 'package:qrcode_akillisletme/product/theme/app_theme_variant.dart';
import 'package:qrcode_akillisletme/product/theme/state/theme/theme_state.dart';

export 'package:qrcode_akillisletme/product/theme/state/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          const ThemeState(
            variant: AppThemeVariant.purple,
            themeMode: ThemeMode.system,
          ),
        ) {
    _load();
  }

  void _load() {
    final variantKey =
        locator.sharedCache.getValue<String>(SharedKeys.themeVariant);
    final themeMode = locator.sharedCache.themeMode;

    emit(
      ThemeState(
        variant:
            variantKey != null ? AppThemeVariant.fromKey(variantKey) : state.variant,
        themeMode: themeMode,
      ),
    );
  }

  Future<void> setVariant(AppThemeVariant variant) async {
    await locator.sharedCache
        .setValue<String>(SharedKeys.themeVariant, variant.key);
    emit(state.copyWith(variant: variant));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await locator.sharedCache.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }
}
