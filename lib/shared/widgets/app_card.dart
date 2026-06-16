import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.gradient,
    this.elevation,
    this.borderRadius,
    this.border,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.card);
    final depth = elevation ?? 1.0;

    Widget card = Container(
      decoration: BoxDecoration(
        color: gradient == null ? color ?? AppColors.warmIvory : null,
        gradient: gradient,
        borderRadius: radius,
        border: border ?? Border.all(color: AppColors.softBorder, width: 1),
        boxShadow: depth > 0
            ? [
                BoxShadow(
                  color: AppColors.ambientShadow,
                  blurRadius: 18 * depth,
                  offset: Offset(0, 8 * depth),
                ),
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 28 * depth,
                  offset: Offset(0, 12 * depth),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.oliveGreen.withAlpha(20),
          highlightColor: AppColors.oliveLight.withAlpha(60),
          child: card,
        ),
      );
    }

    return card;
  }
}

class PremiumCard extends AppCard {
  const PremiumCard({
    super.key,
    required super.child,
    super.padding,
    super.onTap,
    super.color,
    super.gradient,
    super.elevation,
    super.borderRadius,
    super.border,
    super.clipBehavior,
  });
}
