import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.button);

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        width: widget.fullWidth ? double.infinity : null,
        height: _height,
        child: DecoratedBox(
          decoration: _decoration(radius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enabled ? widget.onPressed : null,
              onTapDown:
                  _enabled ? (_) => setState(() => _pressed = true) : null,
              onTapUp:
                  _enabled ? (_) => setState(() => _pressed = false) : null,
              onTapCancel:
                  _enabled ? () => setState(() => _pressed = false) : null,
              borderRadius: radius,
              splashColor: _foregroundColor.withAlpha(28),
              highlightColor: _foregroundColor.withAlpha(18),
              child: Padding(
                padding: _padding,
                child: Center(child: _buildChild()),
              ),
            ),
          ),
        ),
      ),
    ).animate(target: _enabled ? 1 : 0.55).fade(duration: 180.ms);
  }

  Widget _buildChild() {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _loadingColor,
        ),
      );
    }

    final text = Text(
      widget.label,
      style: _textStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    if (widget.icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: _iconSize, color: _foregroundColor),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: text),
      ],
    );
  }

  BoxDecoration _decoration(BorderRadius radius) {
    final border = _border;
    final isElevated = _enabled &&
        (widget.variant == AppButtonVariant.primary ||
            widget.variant == AppButtonVariant.secondary ||
            widget.variant == AppButtonVariant.danger);

    return BoxDecoration(
      color: _gradient == null ? _backgroundColor : null,
      gradient: _enabled ? _gradient : null,
      borderRadius: radius,
      border: border,
      boxShadow: isElevated
          ? [
              BoxShadow(
                color: _shadowColor,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              const BoxShadow(
                color: AppColors.ambientShadow,
                blurRadius: 30,
                offset: Offset(0, 16),
              ),
            ]
          : null,
    );
  }

  Gradient? get _gradient {
    if (!_enabled) return null;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.primaryGradient;
      case AppButtonVariant.secondary:
        return AppColors.warmGradient;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
      case AppButtonVariant.danger:
        return null;
    }
  }

  Color get _backgroundColor {
    if (!_enabled) return AppColors.softBeige;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.oliveGreen;
      case AppButtonVariant.secondary:
        return AppColors.terracotta;
      case AppButtonVariant.outline:
        return AppColors.warmIvory;
      case AppButtonVariant.ghost:
        return AppColors.creamCanvas;
      case AppButtonVariant.danger:
        return AppColors.errorRed;
    }
  }

  Color get _foregroundColor {
    if (!_enabled) return AppColors.mutedText;
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.danger:
        return AppColors.white;
      case AppButtonVariant.outline:
        return AppColors.oliveGreen;
      case AppButtonVariant.ghost:
        return AppColors.charcoal;
    }
  }

  Border? get _border {
    if (!_enabled) return Border.all(color: AppColors.lightBorder);
    switch (widget.variant) {
      case AppButtonVariant.outline:
        return Border.all(
            color: AppColors.oliveGreen.withAlpha(150), width: 1.2);
      case AppButtonVariant.ghost:
        return Border.all(color: AppColors.softBorder, width: 1.2);
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.danger:
        return Border.all(color: AppColors.white.withAlpha(34));
    }
  }

  Color get _shadowColor {
    switch (widget.variant) {
      case AppButtonVariant.secondary:
        return AppColors.terracotta.withAlpha(60);
      case AppButtonVariant.danger:
        return AppColors.errorRed.withAlpha(55);
      case AppButtonVariant.primary:
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppColors.oliveGreen.withAlpha(55);
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 9);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 22, vertical: 13);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 15);
    }
  }

  double get _height {
    switch (widget.size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 52;
      case AppButtonSize.large:
        return 58;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  TextStyle get _textStyle {
    final base = AppTypography.buttonText.copyWith(color: _foregroundColor);
    switch (widget.size) {
      case AppButtonSize.small:
        return base.copyWith(fontSize: 13);
      case AppButtonSize.medium:
        return base.copyWith(fontSize: 15);
      case AppButtonSize.large:
        return base.copyWith(fontSize: 16);
    }
  }

  Color get _loadingColor {
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.danger:
        return AppColors.white;
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppColors.oliveGreen;
    }
  }
}

class PremiumButton extends AppButton {
  const PremiumButton({
    super.key,
    required super.label,
    super.onPressed,
    super.variant = AppButtonVariant.primary,
    super.size = AppButtonSize.medium,
    super.icon,
    super.isLoading = false,
    super.fullWidth = true,
  });
}
