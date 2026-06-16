import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminMealsScreen extends ConsumerStatefulWidget {
  const AdminMealsScreen({super.key});

  @override
  ConsumerState<AdminMealsScreen> createState() => _AdminMealsScreenState();
}

class _AdminMealsScreenState extends ConsumerState<AdminMealsScreen> {
  @override
  Widget build(BuildContext context) {
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
                      onToggleFeatured: (val) {
                        setState(() {
                          final idx = MockMeals.meals
                              .indexWhere((m) => m.id == entry.value.id);
                          if (idx != -1) {
                            MockMeals.meals[idx] =
                                entry.value.copyWith(isFeatured: val);
                          }
                        });
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, [MealModel? meal]) {
    final nameCtrl = TextEditingController(text: meal?.name ?? '');
    final descCtrl = TextEditingController(text: meal?.description ?? '');
    final priceCtrl = TextEditingController(
        text: meal != null ? meal.price.toStringAsFixed(2) : '');
    final calCtrl =
        TextEditingController(text: meal != null ? meal.calories.toString() : '');
    final prepCtrl = TextEditingController(
        text: meal != null ? meal.preparationTimeMinutes.toString() : '');
    String selectedCategoryId =
        meal?.categoryId ?? MockMeals.categories.first.id;
    bool isAvailable = meal?.isAvailable ?? true;
    bool isFeatured = meal?.isFeatured ?? false;

    AppBottomSheet.show(
      context,
      title: meal == null ? 'New meal' : 'Edit meal',
      child: StatefulBuilder(
        builder: (context, setStateSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            0,
            AppSpacing.pagePadding,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Meal Name',
                hint: 'Mediterranean Grain Bowl',
                controller: nameCtrl,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Description',
                hint: 'Fresh ingredients, dressing...',
                controller: descCtrl,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Price (\$)',
                      hint: '15.50',
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Calories',
                      hint: '500',
                      controller: calCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Prep Time (min)',
                      hint: '12',
                      controller: prepCtrl,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category', style: AppTypography.caption),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.creamBackground,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.softBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategoryId,
                              isExpanded: true,
                              items: MockMeals.categories.map((cat) {
                                return DropdownMenuItem<String>(
                                  value: cat.id,
                                  child: Text(cat.name,
                                      style: AppTypography.bodySm),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setStateSheet(() {
                                    selectedCategoryId = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle,
                          size: 12, color: AppColors.oliveGreen),
                      const SizedBox(width: 8),
                      Text('Available', style: AppTypography.bodySm),
                    ],
                  ),
                  Switch(
                    value: isAvailable,
                    onChanged: (val) {
                      setStateSheet(() {
                        isAvailable = val;
                      });
                    },
                    activeThumbColor: AppColors.oliveGreen,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 16, color: AppColors.warmGold),
                      const SizedBox(width: 8),
                      Text('Featured', style: AppTypography.bodySm),
                    ],
                  ),
                  Switch(
                    value: isFeatured,
                    onChanged: (val) {
                      setStateSheet(() {
                        isFeatured = val;
                      });
                    },
                    activeThumbColor: AppColors.warmGold,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: meal == null ? 'Create Meal' : 'Save Changes',
                icon: Icons.save_outlined,
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a meal name')),
                    );
                    return;
                  }
                  final parsedPrice = double.tryParse(priceCtrl.text) ?? 15.00;
                  final parsedCals = int.tryParse(calCtrl.text) ?? 450;
                  final parsedPrep = int.tryParse(prepCtrl.text) ?? 15;
                  final categoryName = MockMeals.categories
                      .firstWhere((cat) => cat.id == selectedCategoryId)
                      .name;

                  setState(() {
                    if (meal != null) {
                      final idx = MockMeals.meals
                          .indexWhere((m) => m.id == meal.id);
                      if (idx != -1) {
                        MockMeals.meals[idx] = meal.copyWith(
                          name: nameCtrl.text.trim(),
                          description: descCtrl.text.trim(),
                          price: parsedPrice,
                          calories: parsedCals,
                          preparationTimeMinutes: parsedPrep,
                          categoryId: selectedCategoryId,
                          categoryName: categoryName,
                          isAvailable: isAvailable,
                          isFeatured: isFeatured,
                        );
                      }
                    } else {
                      final newMeal = MealModel(
                        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        price: parsedPrice,
                        categoryId: selectedCategoryId,
                        categoryName: categoryName,
                        imageUrl:
                            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
                        calories: parsedCals,
                        preparationTimeMinutes: parsedPrep,
                        isAvailable: isAvailable,
                        isFeatured: isFeatured,
                        createdAt: DateTime.now(),
                      );
                      MockMeals.meals.insert(0, newMeal);
                    }
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        meal == null
                            ? 'Meal "${nameCtrl.text.trim()}" created successfully!'
                            : 'Changes saved for "${nameCtrl.text.trim()}".',
                      ),
                      backgroundColor: AppColors.oliveGreen,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
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
  final ValueChanged<bool> onToggleFeatured;

  const _MealAdminTile({
    required this.meal,
    required this.index,
    required this.onEdit,
    required this.onToggleFeatured,
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
                onChanged: onToggleFeatured,
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
