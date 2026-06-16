import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/meal_card.dart';

final _selectedCategoryProvider = StateProvider<String?>((ref) => null);
final _searchQueryProvider = StateProvider<String>((ref) => '');
final _selectedTagsProvider = StateProvider<List<String>>((ref) => []);

class MealsListScreen extends ConsumerWidget {
  const MealsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(_selectedCategoryProvider);
    final query = ref.watch(_searchQueryProvider);
    final selectedTags = ref.watch(_selectedTagsProvider);

    List<MealModel> meals = MockMeals.meals;
    if (selectedCat != null) meals = MockMeals.getMealsByCategory(selectedCat);
    if (query.isNotEmpty) meals = MockMeals.searchMeals(query);
    if (selectedTags.isNotEmpty) {
      meals = meals
          .where((m) => selectedTags.any((t) => m.dietaryTags.contains(t)))
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Curated menu',
                        style:
                            AppTypography.displayMedium.copyWith(fontSize: 34)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Office-friendly meals with clear nutrition, prep times, and dietary flags.',
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.mutedText),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _SearchBar(ref: ref),
                    const SizedBox(height: AppSpacing.lg),
                    _CategoryChips(ref: ref),
                    const SizedBox(height: AppSpacing.md),
                    _DietaryFilters(ref: ref),
                    const SizedBox(height: AppSpacing.sectionSpacing),
                    SectionHeader(
                      title: '${meals.length} meals available',
                      subtitle: selectedCat == null
                          ? 'All categories'
                          : _categoryName(selectedCat),
                    ),
                  ],
                ),
              ),
            ),
            if (meals.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  icon: Icons.no_food_outlined,
                  title: 'No meals found',
                  message: 'Try another category or remove a dietary filter.',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    ref.read(_selectedCategoryProvider.notifier).state = null;
                    ref.read(_searchQueryProvider.notifier).state = '';
                    ref.read(_selectedTagsProvider.notifier).state = [];
                  },
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  0,
                  AppSpacing.pagePadding,
                  AppSpacing.huge,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => Padding(
                      padding: EdgeInsets.only(
                        bottom: i == meals.length - 1 ? 0 : AppSpacing.lg,
                      ),
                      child: MealCard(
                        meal: meals[i],
                        onTap: () =>
                            context.push('/client/meals/${meals[i].id}'),
                        onAddToCart: () => _addToCart(context, meals[i].name),
                      ).animate().fade(
                            delay: Duration(milliseconds: i * 55),
                            duration: 250.ms,
                          ),
                    ),
                    childCount: meals.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _categoryName(String id) {
    return MockMeals.categories
        .firstWhere((category) => category.id == id)
        .name;
  }

  static void _addToCart(BuildContext context, String mealName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$mealName added to order')),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final WidgetRef ref;

  const _SearchBar({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.white.withAlpha(180)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: TextField(
        onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
        style: AppTypography.bodyMd,
        cursorColor: AppColors.oliveGreen,
        decoration: InputDecoration(
          hintText: 'Search bowls, salmon, vegan, coffee...',
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.oliveGreen),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.lg),
          hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final WidgetRef ref;

  const _CategoryChips({required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(_selectedCategoryProvider);
    final categories = [null, ...MockMeals.categories];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected =
              cat == null ? selected == null : selected == cat.id;
          return GestureDetector(
            onTap: () =>
                ref.read(_selectedCategoryProvider.notifier).state = cat?.id,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.oliveGreen : AppColors.warmIvory,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color:
                      isSelected ? AppColors.oliveGreen : AppColors.softBorder,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.oliveGreen.withAlpha(38),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                cat == null ? 'All' : cat.name,
                style: AppTypography.labelMd.copyWith(
                  color: isSelected ? AppColors.white : AppColors.charcoal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DietaryFilters extends StatelessWidget {
  final WidgetRef ref;

  const _DietaryFilters({required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(_selectedTagsProvider);
    const tags = [
      'Vegetarian',
      'Vegan',
      'Gluten-Free',
      'High Protein',
      'Halal'
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        final isSelected = selected.contains(tag);
        return GestureDetector(
          onTap: () {
            final current = List<String>.from(selected);
            if (isSelected) {
              current.remove(tag);
            } else {
              current.add(tag);
            }
            ref.read(_selectedTagsProvider.notifier).state = current;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppColors.terracottaLight : AppColors.warmIvory,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? AppColors.terracotta.withAlpha(80)
                    : AppColors.softBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_rounded,
                      size: 14, color: AppColors.terracotta),
                  const SizedBox(width: 5),
                ],
                Text(
                  tag,
                  style: AppTypography.labelSm.copyWith(
                    color:
                        isSelected ? AppColors.terracotta : AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
