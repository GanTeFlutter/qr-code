import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qrcode_akillisletme/feature/home/home_view.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/onboarding_view.dart';
import 'package:qrcode_akillisletme/feature/login_process/splash/splash_view.dart';
import 'package:qrcode_akillisletme/feature/login_process/splash/state/splash_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/state/create_qr_cubit.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/view/create_qr_view.dart';
import 'package:qrcode_akillisletme/feature/qr/create_qr/view/qr_form_view.dart';
import 'package:qrcode_akillisletme/feature/qr/history/history_view.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/scanner_view.dart';
import 'package:qrcode_akillisletme/feature/qr/scanner/state/scanner_cubit.dart';
import 'package:qrcode_akillisletme/feature/settings/about/about_view.dart';
import 'package:qrcode_akillisletme/feature/settings/language_selection/language_selection_view.dart';
import 'package:qrcode_akillisletme/feature/settings/settings_view.dart';
import 'package:qrcode_akillisletme/product/cache/hive_v2/model/qr_history_cache_model.dart';
import 'package:qrcode_akillisletme/product/navigation/route_transitions.dart';
import 'package:qrcode_akillisletme/product/service/service_locator.dart';

part 'app_router.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: BlocProvider(
        create: (_) => SplashCubit(
          remoteConfigService: locator.remoteConfigService,
        )..checkApp(),
        child: const SplashView(),
      ),
    );
  }
}

@TypedGoRoute<OnboardingRoute>(path: '/onboarding')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: const OnboardingView(),
    );
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ScannerRoute>(path: 'scanner'),
    TypedGoRoute<CreateQrRoute>(path: 'create-qr'),
    TypedGoRoute<HistoryRoute>(path: 'history'),
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: [
        TypedGoRoute<AboutRoute>(path: 'about'),
        TypedGoRoute<LanguageSelectionRoute>(path: 'language'),
      ],
    ),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(key: state.pageKey, child: const HomeView());
  }
}

class ScannerRoute extends GoRouteData with $ScannerRoute {
  const ScannerRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: BlocProvider(
        create: (_) => ScannerCubit(
          historyService: locator.historyService,
        ),
        child: const ScannerView(),
      ),
    );
  }
}

class CreateQrRoute extends GoRouteData with $CreateQrRoute {
  const CreateQrRoute({this.$extra});

  final QrHistoryCacheModel? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final historyItem = $extra;
    if (historyItem != null) {
      final cubit = CreateQrCubit()
        ..loadFromHistory(
          content: historyItem.content,
          qrTypeName: historyItem.qrTypeName,
        );
      final selectedType = cubit.state.selectedType;
      if (selectedType != null) {
        return slideRightTransition(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => cubit,
            child: QrFormView(
              type: selectedType,
              initialData: cubit.state.formData,
            ),
          ),
        );
      }
    }

    return slideRightTransition(
      key: state.pageKey,
      child: BlocProvider(
        create: (_) => CreateQrCubit(),
        child: const CreateQrView(),
      ),
    );
  }
}

class HistoryRoute extends GoRouteData with $HistoryRoute {
  const HistoryRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: const HistoryView(),
    );
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: const SettingsView(),
    );
  }
}

class LanguageSelectionRoute extends GoRouteData with $LanguageSelectionRoute {
  const LanguageSelectionRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: const LanguageSelectionView(),
    );
  }
}

class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: const AboutView(),
    );
  }
}

/// App router configuration
final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: $appRoutes,
    redirect: _routeGuard,
  );

  static String? _routeGuard(BuildContext context, GoRouterState state) {
    final isOnboardingDone = locator.sharedCache.isOnboardingCompleted;
    final location = state.matchedLocation;

    // Onboarding tamamlandiysa tekrar /onboarding'e gitmesini engelle
    if (location == '/onboarding' && isOnboardingDone) {
      return '/';
    }

    return null;
  }
}
