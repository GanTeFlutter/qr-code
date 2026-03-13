import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:qrcode_akillisletme/feature/home/widget/home_background.dart';

/// Uygulama yasam dongusu olaylarini dinler.
/// Arka plana geciste animasyonlari duraklatir,
/// on plana donuste devam ettirir.
class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver._();

  static final _instance = AppLifecycleObserver._();

  /// Uygulamanin basinda cagirilmali.
  static void init() {
    WidgetsBinding.instance.addObserver(_instance);
  }

  /// Uygulama kapanirken cagirilabilir.
  static void dispose() {
    WidgetsBinding.instance.removeObserver(_instance);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Arka plana geciste animasyonlari durdur
        HomeBackground.enabledNotifier.value = false;
        log('App paused — animasyonlar duraklatildi');

      case AppLifecycleState.resumed:
        // On plana donuste animasyonlari baslat (kullanici ayarina gore)
        HomeBackground.enabledNotifier.value = true;
        log('App resumed — animasyonlar devam ediyor');

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
