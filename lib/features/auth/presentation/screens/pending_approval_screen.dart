import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.warmGold.withAlpha(100), width: 3),
                ),
                child: const Icon(Icons.schedule_rounded,
                    size: 48, color: AppColors.warmGold),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .fade(duration: 400.ms),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Application Submitted!',
                style: AppTypography.headingLg,
                textAlign: TextAlign.center,
              ).animate().fade(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Your company account is pending review by our team. We'll notify you by email once it's approved.",
                style:
                    AppTypography.bodyLg.copyWith(color: AppColors.mutedText),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 450.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxxl),
              const _TimelineStep(
                icon: Icons.check_circle_rounded,
                label: 'Application Submitted',
                description: 'Your company details have been received.',
                isCompleted: true,
                index: 0,
              ),
              const SizedBox(height: AppSpacing.lg),
              const _TimelineStep(
                icon: Icons.manage_search_rounded,
                label: 'Under Review',
                description: 'Our team will verify your company information.',
                isCompleted: false,
                isActive: true,
                index: 1,
              ),
              const SizedBox(height: AppSpacing.lg),
              const _TimelineStep(
                icon: Icons.verified_rounded,
                label: 'Approved & Ready',
                description:
                    "You'll receive an email and can start using Platter.",
                isCompleted: false,
                index: 2,
              ),
              const SizedBox(height: AppSpacing.huge),
              AppButton(
                label: 'Back to Home',
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
                variant: AppButtonVariant.outline,
              ).animate().fade(delay: 900.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Approval typically takes 1–2 business days.',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ).animate().fade(delay: 1000.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isCompleted;
  final bool isActive;
  final int index;

  const _TimelineStep({
    required this.icon,
    required this.label,
    required this.description,
    required this.isCompleted,
    this.isActive = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.oliveGreen
                : isActive
                    ? AppColors.goldLight
                    : AppColors.softBeige,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? AppColors.oliveGreen
                  : isActive
                      ? AppColors.warmGold
                      : AppColors.lightBorder,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isCompleted
                ? AppColors.white
                : isActive
                    ? AppColors.warmGold
                    : AppColors.mutedText,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.titleSm.copyWith(
                  color: isCompleted || isActive
                      ? AppColors.charcoal
                      : AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypography.bodySm,
              ),
            ],
          ),
        ),
      ],
    ).animate().fade(
        delay: Duration(milliseconds: 500 + index * 150), duration: 400.ms);
  }
}
