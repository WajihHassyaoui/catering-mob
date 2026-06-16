import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/models/meal_model.dart';
import 'app_button.dart';
import 'common_widgets.dart';

class MealCard extends StatefulWidget {
  final MealModel meal;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final bool compact;

  const MealCard({
    super.key,
    required this.meal,
    this.onTap,
    this.onAddToCart,
    this.isFavorite = false,
    this.onToggleFavorite,
    this.compact = false,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _handleFavorite() {
    _heartCtrl.forward().then((_) => _heartCtrl.reverse());
    widget.onToggleFavorite?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.99 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: widget.onTap == null
            ? null
            : (_) => setState(() => _pressed = true),
        onTapUp: widget.onTap == null
            ? null
            : (_) => setState(() => _pressed = false),
        onTapCancel: widget.onTap == null
            ? null
            : () => setState(() => _pressed = false),
        child: widget.compact ? _buildCompact() : _buildFull(),
      ),
    );
  }

  Widget _buildFull() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _buildImage(height: 154),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              0,
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
            ),
            child: _buildInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact() {
    return Container(
      width: 188,
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(9),
            child: _buildImage(height: 112, compact: true),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.meal.name,
                  style: AppTypography.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      widget.meal.formattedPrice,
                      style: AppTypography.labelMd
                          .copyWith(color: AppColors.terracotta),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.warmGold),
                    const SizedBox(width: 2),
                    Text(
                      widget.meal.rating.toStringAsFixed(1),
                      style: AppTypography.caption
                          .copyWith(color: AppColors.charcoal),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      gradient: AppColors.cardGradient,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(color: AppColors.white.withAlpha(180)),
      boxShadow: const [
        BoxShadow(
          color: AppColors.ambientShadow,
          blurRadius: 22,
          offset: Offset(0, 12),
        ),
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildImage({required double height, bool compact = false}) {
    return Stack(
      children: [
        PremiumImage(
          imageUrl: widget.meal.imageUrl,
          height: height,
          borderRadius: BorderRadius.circular(AppRadius.image),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.image),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.overlayDark.withAlpha(compact ? 40 : 72),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        if (widget.meal.isFeatured)
          Positioned(
            top: 10,
            left: 10,
            child: _floatingBadge(
              icon: Icons.auto_awesome_rounded,
              label: 'Chef pick',
              color: AppColors.warmGold,
            ),
          ),
        Positioned(
          right: 10,
          bottom: 10,
          child: _floatingBadge(
            icon: Icons.payments_outlined,
            label: widget.meal.formattedPrice,
            color: AppColors.white,
            textColor: AppColors.charcoal,
          ),
        ),
        if (widget.onToggleFavorite != null)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _handleFavorite,
              child: AnimatedBuilder(
                animation: _heartCtrl,
                builder: (_, __) => Transform.scale(
                  scale: 1.0 + _heartCtrl.value * 0.28,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(230),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: widget.isFavorite
                          ? AppColors.terracotta
                          : AppColors.charcoal,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.meal.name,
                style: AppTypography.titleMd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            if (widget.meal.rating > 0) _rating(),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          widget.meal.description,
          style: AppTypography.bodySm.copyWith(color: AppColors.mutedText),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            InfoPill(
              icon: Icons.local_fire_department_rounded,
              label: '${widget.meal.calories} cal',
              color: AppColors.terracotta,
            ),
            InfoPill(
              icon: Icons.bolt_rounded,
              label: _proteinLabel,
              color: AppColors.oliveGreen,
            ),
            InfoPill(
              icon: Icons.schedule_rounded,
              label: widget.meal.prepTime,
              color: AppColors.mutedText,
            ),
          ],
        ),
        if (widget.meal.dietaryTags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.meal.dietaryTags.take(3).map(_dietaryTag).toList(),
          ),
        ],
        if (widget.onAddToCart != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Add to order',
            onPressed: widget.onAddToCart,
            icon: Icons.add_rounded,
            size: AppButtonSize.small,
          ),
        ],
      ],
    );
  }

  Widget _floatingBadge({
    required IconData icon,
    required String label,
    required Color color,
    Color? textColor,
  }) {
    final foreground = textColor ?? AppColors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color == AppColors.white
            ? AppColors.white.withAlpha(228)
            : color.withAlpha(230),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.white.withAlpha(90)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rating() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.warmGold),
          const SizedBox(width: 3),
          Text(
            widget.meal.rating.toStringAsFixed(1),
            style: AppTypography.caption.copyWith(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dietaryTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.oliveLight,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.oliveGreen.withAlpha(24)),
      ),
      child: Text(
        tag,
        style: AppTypography.caption.copyWith(
          color: AppColors.oliveGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get _proteinLabel {
    if (widget.meal.dietaryTags.contains('High Protein')) return 'Protein rich';
    if (widget.meal.dietaryTags.contains('Vegan')) return 'Plant based';
    if (widget.meal.dietaryTags.contains('Vegetarian')) return 'Vegetarian';
    return widget.meal.allergens.isEmpty
        ? 'Allergen clear'
        : '${widget.meal.allergens.length} allergens';
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardStatCard(
      title: title,
      value: value,
      icon: icon,
      color: color,
      subtitle: subtitle,
      onTap: onTap,
      progress: subtitle == null ? 0 : 0.72,
    );
  }
}
