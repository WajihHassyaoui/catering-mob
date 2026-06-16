import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final auth = ref.read(authProvider);
    if (auth.status == AuthStatus.initial ||
        auth.status == AuthStatus.loading) {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (!mounted) return;
    final current = ref.read(authProvider);

    if (current.isAuthenticated && current.user != null) {
      switch (current.user!.role) {
        case 'client':
          context.go('/client');
          break;
        case 'company':
          context.go('/company');
          break;
        case 'admin':
          context.go('/admin');
          break;
        default:
          context.go('/onboarding');
      }
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.oliveGreen.withAlpha(48),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                size: 52,
                color: AppColors.white,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.3, 0.3),
                  duration: 700.ms,
                  curve: Curves.elasticOut,
                )
                .fade(duration: 500.ms),
            const SizedBox(height: 28),
            Text(
              'Platter',
              style: AppTypography.displayBold.copyWith(
                color: AppColors.charcoal,
                letterSpacing: 0,
              ),
            )
                .animate()
                .fade(delay: 400.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 6),
            Text(
              'Catering',
              style: AppTypography.headingMd.copyWith(
                color: AppColors.oliveGreen,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            )
                .animate()
                .fade(delay: 550.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 16),
            Text(
              'Premium Corporate Catering & Meal Prep',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                letterSpacing: 0,
              ),
            ).animate().fade(delay: 700.ms, duration: 400.ms),
            const SizedBox(height: 80),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.oliveGreen.withAlpha(150),
              ),
            ).animate().fade(delay: 1000.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
