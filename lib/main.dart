import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/product/init/app_builder.dart';
import 'package:qrcode_akillisletme/product/init/application_init.dart';
import 'package:qrcode_akillisletme/product/init/language/core_localize.dart';
import 'package:qrcode_akillisletme/product/init/state_initialize.dart';
import 'package:qrcode_akillisletme/product/navigation/app_router.dart';
import 'package:qrcode_akillisletme/product/theme/state/theme/theme_cubit.dart';
import 'package:qrcode_akillisletme/product/theme/theme.dart';

void main() async {
  await const ApplicationInit().start();
  _setupErrorHandling();
  runApp(
    EasyLocalization(
      supportedLocales: CoreLocalize.supportedItems,
      path: CoreLocalize.initialPath,
      startLocale: CoreLocalize.startLocale,
      useOnlyLangCode: true,
      child: const StateInitialize(child: QrApp()),
    ),
  );
}

void _setupErrorHandling() {
  FlutterError.onError = (details) {
    log(
      'FlutterError: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
}

class QrApp extends StatelessWidget {
  const QrApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return MaterialApp.router(
      title: 'QR',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      darkTheme: AppTheme.darkTheme(themeState.variant),
      theme: AppTheme.lightTheme(themeState.variant),
      routerConfig: AppRouter.router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: AppBuilder.call,
    );
  }
}
