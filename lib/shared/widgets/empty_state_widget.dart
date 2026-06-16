import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'app_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (iconColor ?? AppColors.oliveGreen).withAlpha(38),
                    AppColors.warmIvory,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.white.withAlpha(180)),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ambientShadow,
                    blurRadius: 28,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 44,
                color: (iconColor ?? AppColors.oliveGreen).withAlpha(180),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.7, 0.7),
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                )
                .fade(duration: 300.ms),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: AppTypography.titleLg.copyWith(color: AppColors.charcoal),
              textAlign: TextAlign.center,
            )
                .animate()
                .fade(delay: 150.ms, duration: 300.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            )
                .animate()
                .fade(delay: 250.ms, duration: 300.ms)
                .slideY(begin: 0.3, end: 0),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
                size: AppButtonSize.medium,
              )
                  .animate()
                  .fade(delay: 350.ms, duration: 300.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  const LoadingSkeleton.line({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  const LoadingSkeleton.circle({
    super.key,
    required double size,
    this.borderRadius,
  })  : width = size,
        height = size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.sm),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          color: AppColors.shimmerHighlight,
        );
  }
}

class CardSkeleton extends StatelessWidget {
  final bool large;

  const CardSkeleton({super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.softBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (large) ...[
            LoadingSkeleton(
              width: double.infinity,
              height: 132,
              borderRadius: BorderRadius.circular(AppRadius.image),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Row(
            children: [
              const LoadingSkeleton.circle(size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingSkeleton.line(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 14),
                    const SizedBox(height: 8),
                    const LoadingSkeleton.line(height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton.line(height: 12),
          const SizedBox(height: 6),
          const LoadingSkeleton.line(height: 12),
          const SizedBox(height: 6),
          LoadingSkeleton.line(
              width: MediaQuery.of(context).size.width * 0.5, height: 12),
        ],
      ),
    );
  }
}

class ShimmerLoadingCard extends CardSkeleton {
  const ShimmerLoadingCard({super.key, super.large = true});
}
