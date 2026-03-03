import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigator.push icin slide + fade gecisi.
Route<T> slideRightRoute<T>(Widget child) {
  return PageRouteBuilder<T>(
    opaque: false,
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return _withExitFade(
        secondaryAnimation,
        FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Eski sayfayı fade-out yaparak geçiş sırasında kötü görünümü önler.
/// Arka plan animasyonu her zaman görünür olduğundan, çıkan sayfa
/// hızlıca solarak kaybolmalı.
Widget _withExitFade(Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: ReverseAnimation(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    ),
    child: child,
  );
}

/// Sağdan sola kayarak açılan sayfa geçişi + exit fade
Page<dynamic> slideRightTransition({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return _withExitFade(
        secondaryAnimation,
        FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Hafif fade geçişi + exit fade
Page<dynamic> fadeTransition({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _withExitFade(
        secondaryAnimation,
        FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
    },
  );
}
