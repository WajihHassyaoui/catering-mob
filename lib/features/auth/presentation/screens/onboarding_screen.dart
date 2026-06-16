import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardingPage(
      imageUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=900',
      title: 'Premium catering for modern offices',
      subtitle:
          'Curated meals, chef-led catering, and office-ready delivery without operational noise.',
      icon: Icons.restaurant_rounded,
    ),
    _OnboardingPage(
      imageUrl:
          'https://images.unsplash.com/photo-1555244162-803834f70033?w=900',
      title: 'Group ordering without the spreadsheet',
      subtitle:
          'Managers set the order, employees choose their meals, and everything rolls into one clean invoice.',
      icon: Icons.groups_rounded,
    ),
    _OnboardingPage(
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
      title: 'Meal plans that feel considered',
      subtitle:
          'Recurring office lunches with dietary preferences, spending limits, and delivery schedules built in.',
      icon: Icons.calendar_month_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/choose-role'),
                  child: Text('Skip',
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.oliveGreen)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                ),
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: const ExpandingDotsEffect(
                  dotColor: AppColors.softBeige,
                  activeDotColor: AppColors.oliveGreen,
                  dotHeight: 7,
                  dotWidth: 7,
                  expansionFactor: 4,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: isLast ? 'Get started' : 'Continue',
                icon: isLast
                    ? Icons.arrow_forward_rounded
                    : Icons.keyboard_arrow_right_rounded,
                onPressed: () {
                  if (isLast) {
                    context.go('/choose-role');
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Already have an account? Log in',
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.mutedText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 520;
        final imageHeight = (constraints.maxHeight * (compact ? 0.42 : 0.48))
            .clamp(150.0, 300.0)
            .toDouble();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warmIvory,
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(color: AppColors.white.withAlpha(180)),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.ambientShadow,
                        blurRadius: 30,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      PremiumImage(
                        imageUrl: page.imageUrl,
                        height: imageHeight,
                        borderRadius: BorderRadius.circular(28),
                        icon: page.icon,
                      ),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: Container(
                          width: compact ? 46 : 54,
                          height: compact ? 46 : 54,
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(230),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(page.icon, color: AppColors.oliveGreen),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms).slideY(begin: 0.05, end: 0),
                SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xxxl),
                Text(
                  page.title,
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: compact ? 30 : 36,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fade(delay: 120.ms, duration: 300.ms),
                const SizedBox(height: AppSpacing.md),
                Text(
                  page.subtitle,
                  style:
                      AppTypography.bodyLg.copyWith(color: AppColors.mutedText),
                  textAlign: TextAlign.center,
                ).animate().fade(delay: 200.ms, duration: 300.ms),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingPage {
  final String imageUrl;
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingPage({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
