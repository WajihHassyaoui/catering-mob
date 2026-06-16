import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminMealsScreen extends ConsumerWidget {
  const AdminMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = MockMeals.meals;
    final featured = meals.where((m) => m.isFeatured).length;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.xl,
            AppSpacing.pagePadding,
            AppSpacing.huge,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Menu curator',
                          style: AppTypography.displayMedium
                              .copyWith(fontSize: 34)),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '$featured featured meals across ${MockMeals.categories.length} categories.',
                        style: AppTypography.bodyMd
                            .copyWith(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  label: 'Add',
                  icon: Icons.add_rounded,
                  fullWidth: false,
                  size: AppButtonSize.small,
                  onPressed: () => _showEditSheet(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _MenuHealth(meals: meals),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const SectionHeader(
              title: 'Editable menu',
              subtitle: 'Prices, nutrition, categories, and featured status.',
            ),
            const SizedBox(height: AppSpacing.md),
            ...meals.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _MealAdminTile(
                      meal: entry.value,
                      index: entry.key,
                      onEdit: () => _showEditSheet(context, entry.value),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, [MealModel? meal]) {
    AppBottomSheet.show(
      context,
      title: meal == null ? 'New meal' : 'Edit meal',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          0,
          AppSpacing.pagePadding,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal?.name ?? 'Create a polished menu item',
              style: AppTypography.titleLg,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Editing fields can be connected to the API when menu mutations are available.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Save draft',
              icon: Icons.save_outlined,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuHealth extends StatelessWidget {
  final List<MealModel> meals;

  const _MenuHealth({required this.meals});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DashboardStatCard(
            icon: Icons.restaurant_menu_rounded,
            value: '${meals.length}',
            title: 'Menu items',
            color: AppColors.oliveGreen,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: DashboardStatCard(
            icon: Icons.auto_awesome_rounded,
            value: '${meals.where((m) => m.isFeatured).length}',
            title: 'Featured',
            color: AppColors.warmGold,
          ),
        ),
      ],
    );
  }
}

class _MealAdminTile extends StatelessWidget {
  final MealModel meal;
  final int index;
  final VoidCallback onEdit;

  const _MealAdminTile({
    required this.meal,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              PremiumImage(
                imageUrl: meal.imageUrl,
                width: 72,
                height: 72,
                borderRadius: BorderRadius.circular(18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name,
                        style: AppTypography.titleMd,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(
                      meal.categoryName ?? meal.categoryId,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        InfoPill(
                            icon: Icons.payments_outlined,
                            label: meal.formattedPrice,
                            color: AppColors.terracotta),
                        InfoPill(
                            icon: Icons.local_fire_department_rounded,
                            label: '${meal.calories} cal',
                            color: AppColors.warmGold),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon:
                    const Icon(Icons.edit_outlined, color: AppColors.mutedText),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              StatusBadge.fromStatus(meal.isAvailable ? 'active' : 'inactive',
                  size: BadgeSize.small),
              const Spacer(),
              Text('Featured',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.mutedText)),
              Switch(
                value: meal.isFeatured,
                onChanged: (_) => onEdit(),
                activeThumbColor: AppColors.warmGold,
                activeTrackColor: AppColors.goldLight,
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 45), duration: 240.ms);
  }
}
