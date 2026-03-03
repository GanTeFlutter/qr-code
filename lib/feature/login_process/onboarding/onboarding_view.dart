import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/cubit/onboarding_cubit.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/steps/step1/step_1.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/steps/step2/step_2.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/steps/step3/step_3.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/steps/step4/step_4.dart';
import 'package:qrcode_akillisletme/feature/login_process/onboarding/steps/step_5.dart';
import 'package:qrcode_akillisletme/product/theme/app_theme_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Onboarding akisi — 5 adimlik PageView.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;
  late final OnboardingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _cubit = OnboardingCubit()..pageController = _pageController;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>.value(
      value: _cubit,
      child: Scaffold(
        body: Stack(
          children: [
            // Sayfa icerikleri
            PageView(
              controller: _pageController,
              onPageChanged: _cubit.setPage,
              children: const [Step1(), Step2(), Step3(), Step4(), Step5()],
            ),

            // Alt navigasyon kontrolleri
            _BottomNavigation(pageController: _pageController, cubit: _cubit),
          ],
        ),
      ),
    );
  }
}

/// Alt navigasyon: Sol ok + Indicator + Sag ok
class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.pageController, required this.cubit});

  final PageController pageController;
  final OnboardingCubit cubit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final white =
        Theme.of(context).extension<AppThemeColors>()!.pureWhite;

    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        final isFirstPage = currentPage == 0;
        final isLastPage = currentPage == OnboardingCubit.totalPages - 1;

        return Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol ok
                if (!isFirstPage)
                  IconButton.filled(
                    onPressed: cubit.previousPage,
                    icon: Icon(Icons.arrow_back, color: white),
                    iconSize: 24,
                    style: IconButton.styleFrom(
                      backgroundColor: white.withValues(alpha: 0.2),
                      padding: const EdgeInsets.all(16),
                    ),
                  )
                else
                  const SizedBox(width: 56),

                // Sayfa gostergesi
                SmoothPageIndicator(
                  controller: pageController,
                  count: OnboardingCubit.totalPages,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 12,
                    activeDotColor: white,
                    dotColor: white.withValues(alpha: 0.4),
                  ),
                ),

                // Sag ok
                IconButton.filled(
                  onPressed: isLastPage
                      ? () => cubit.completeOnboarding(context)
                      : cubit.nextPage,
                  icon: Icon(Icons.arrow_forward, color: white),
                  iconSize: 24,
                  style: IconButton.styleFrom(
                    backgroundColor: isLastPage
                        ? cs.primary
                        : white.withValues(alpha: 0.2),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
