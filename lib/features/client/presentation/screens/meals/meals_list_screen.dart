import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/client_providers.dart';
import '../../../../../shared/models/group_order_model.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/meal_card.dart';
import 'cart_sheet.dart';

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
    final activeGroupOrder = ref.watch(activeGroupOrderProvider);

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
        child: Column(
          children: [
            if (activeGroupOrder != null)
              _GroupOrderSelectionBanner(
                groupOrder: activeGroupOrder,
                onCancel: () {
                  ref.read(activeGroupOrderProvider.notifier).state = null;
                },
              ),
            Expanded(
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
                              onAddToCart: () {
                                if (activeGroupOrder != null) {
                                  final meal = meals[i];
                                  final matchIdx = MockData.groupOrders
                                      .indexWhere((go) => go.id == activeGroupOrder.id);
                                  if (matchIdx != -1) {
                                    final targetOrder = MockData.groupOrders[matchIdx];
                                    final existingParticipantIdx = targetOrder.participants
                                        .indexWhere((p) => p.userId == 'u_client_1');

                                    final mealSelection = GroupOrderMealSelection(
                                      mealId: meal.id,
                                      mealName: meal.name,
                                      quantity: 1,
                                      unitPrice: meal.price,
                                    );

                                    GroupOrderParticipant participant;
                                    List<GroupOrderParticipant> updatedParticipants =
                                        List.from(targetOrder.participants);

                                    if (existingParticipantIdx != -1) {
                                      final oldParticipant =
                                          targetOrder.participants[existingParticipantIdx];
                                      participant = GroupOrderParticipant(
                                        id: oldParticipant.id,
                                        userId: oldParticipant.userId,
                                        userName: oldParticipant.userName,
                                        department: oldParticipant.department,
                                        userAvatar: oldParticipant.userAvatar,
                                        mealSelections: [mealSelection],
                                        hasSubmitted: true,
                                        submittedAt: DateTime.now(),
                                      );
                                      updatedParticipants[existingParticipantIdx] = participant;
                                    } else {
                                      participant = GroupOrderParticipant(
                                        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                                        userId: 'u_client_1',
                                        userName: 'Alex Morgan',
                                        department: 'Engineering',
                                        mealSelections: [mealSelection],
                                        hasSubmitted: true,
                                        submittedAt: DateTime.now(),
                                      );
                                      updatedParticipants.add(participant);
                                    }

                                    final newEstimatedTotal =
                                        (targetOrder.estimatedTotal ?? 0) + meal.price;
                                    MockData.groupOrders[matchIdx] = targetOrder.copyWith(
                                      participants: updatedParticipants,
                                      participantCount: updatedParticipants.length,
                                      estimatedTotal: newEstimatedTotal,
                                    );
                                  }

                                  ref.read(activeGroupOrderProvider.notifier).state = null;
                                  ref.read(clientNavIndexProvider.notifier).state = 2;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Meal "${meal.name}" submitted to group order "${activeGroupOrder.name}"!'),
                                      backgroundColor: AppColors.oliveGreen,
                                    ),
                                  );
                                } else {
                                  // Add to personal cart
                                  final meal = meals[i];
                                  ref.read(cartProvider.notifier).addItem(CartItem(
                                    mealId: meal.id,
                                    mealName: meal.name,
                                    mealImageUrl: meal.imageUrl,
                                    unitPrice: meal.price,
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${meal.name} added to cart!'),
                                      backgroundColor: AppColors.oliveGreen,
                                      duration: const Duration(seconds: 2),
                                      action: SnackBarAction(
                                        label: 'VIEW CART',
                                        textColor: Colors.white,
                                        onPressed: () => showCartSheet(context, ref),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ).animate().fade(
                                delay: Duration(milliseconds: i * 55),
                                duration: 250.ms,
                              ),
                          childCount: meals.length,
                        ),
                      ),
                    ),
                ],
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

class _GroupOrderSelectionBanner extends StatelessWidget {
  final GroupOrder groupOrder;
  final VoidCallback onCancel;

  const _GroupOrderSelectionBanner({
    required this.groupOrder,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.oliveLight,
        border: Border(
          bottom: BorderSide(color: AppColors.softBorder),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.oliveGreen.withAlpha(22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.oliveGreen,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selecting meal for group order',
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.mutedText),
                ),
                Text(
                  groupOrder.name,
                  style: AppTypography.titleSm
                      .copyWith(color: AppColors.oliveGreen),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Cancel',
              style: AppTypography.labelSm.copyWith(color: AppColors.terracotta),
            ),
          ),
        ],
      ),
    );
  }
}
