import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_akillisletme/feature/home/widget/home_background.dart';
import 'package:qrcode_akillisletme/product/firebase_options.dart';
import 'package:qrcode_akillisletme/product/init/app_lifecycle_observer.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';

@immutable
final class ApplicationInit {
  const ApplicationInit();

  Future<void> start() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          log('Firebase init timeout — devam ediliyor');
          return Firebase.app();
        },
      );
    } on Exception catch (e) {
      log('Firebase init hatasi: $e');
    }
    await setupLocator();
    HomeBackground.enabledNotifier.value =
        locator.sharedCache.isBackgroundAnimationEnabled;
    AppLifecycleObserver.init();
  }
}
