import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/group_order_model.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../providers/client_providers.dart';
import '../../providers/profile_providers.dart';
import 'cart_sheet.dart';


class MealDetailScreen extends ConsumerStatefulWidget {
  final String mealId;

  const MealDetailScreen({
    super.key,
    required this.mealId,
  });

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final meal = MockMeals.meals.firstWhere(
      (m) => m.id == widget.mealId,
      orElse: () => MockMeals.meals.first,
    );

    final activeGroupOrder = ref.watch(activeGroupOrderProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          // 1. Premium SliverAppBar with Hero Image
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.oliveGreen,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.white.withAlpha(204),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.charcoal, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.white.withAlpha(204),
                  child: Builder(
                    builder: (context) {
                      final isFavorite = ref.watch(favoritesProvider).any((m) => m.id == meal.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: isFavorite ? AppColors.terracotta : AppColors.charcoal,
                          size: 20,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(meal);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                !isFavorite
                                    ? '${meal.name} added to favorites!'
                                    : '${meal.name} removed from favorites.',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    }
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (meal.imageUrl != null)
                    Image.network(
                      meal.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: AppColors.oliveLight,
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 80,
                        color: AppColors.oliveGreen,
                      ),
                    ),
                  // Bottom gradient overlay for typography contrast
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black45,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Info Scroll Content
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  AppSpacing.huge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.oliveLight,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            meal.categoryName ?? 'Curated menu',
                            style: AppTypography.labelSm.copyWith(color: AppColors.oliveGreen),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.warmGold, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              meal.rating.toStringAsFixed(1),
                              style: AppTypography.labelMd.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${meal.reviewCount} reviews)',
                              style: AppTypography.caption.copyWith(color: AppColors.mutedText),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Title & Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            meal.name,
                            style: AppTypography.displayMedium.copyWith(fontSize: 26),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          meal.formattedPrice,
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: 26,
                            color: AppColors.oliveGreen,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Description text
                    Text(
                      meal.description,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.charcoal, height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Nutritional Stats Section
                    const SectionHeader(
                      title: 'Nutritional Info',
                      subtitle: 'Key indicators calculated per standard serving size.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.local_fire_department_outlined,
                            value: '${meal.calories} kcal',
                            label: 'Calories',
                            color: AppColors.terracotta,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.schedule_outlined,
                            value: meal.prepTime,
                            label: 'Prep Time',
                            color: AppColors.warmGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Dietary Tags & Allergens
                    if (meal.dietaryTags.isNotEmpty || meal.allergens.isNotEmpty) ...[
                      const SectionHeader(
                        title: 'Dietary & Allergens',
                        subtitle: 'Clear flags indicating specific diets and food restrictions.',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...meal.dietaryTags.map(
                            (tag) => InfoPill(
                              icon: Icons.check_circle_outline_rounded,
                              label: tag,
                              color: AppColors.oliveGreen,
                            ),
                          ),
                          ...meal.allergens.map(
                            (allergen) => InfoPill(
                              icon: Icons.warning_amber_rounded,
                              label: 'Contains $allergen',
                              color: AppColors.terracotta,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Ingredients Section
                    if (meal.ingredients.isNotEmpty) ...[
                      const SectionHeader(
                        title: 'Ingredients',
                        subtitle: 'Selected raw contents of this fresh recipe.',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: meal.ingredients.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.oliveGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  meal.ingredients[index],
                                  style: AppTypography.bodySm.copyWith(color: AppColors.charcoal),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      // Bottom sticky actions
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.md,
          AppSpacing.pagePadding,
          MediaQuery.of(context).padding.bottom + AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(top: BorderSide(color: AppColors.softBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: activeGroupOrder != null
            ? AppButton(
                label: 'Submit to ${activeGroupOrder.name}',
                icon: Icons.group_add_rounded,
                onPressed: () {
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
                    List<GroupOrderParticipant> updatedParticipants =
                        List.from(targetOrder.participants);
                    if (existingParticipantIdx != -1) {
                      final old = targetOrder.participants[existingParticipantIdx];
                      updatedParticipants[existingParticipantIdx] =
                          GroupOrderParticipant(
                        id: old.id,
                        userId: old.userId,
                        userName: old.userName,
                        department: old.department,
                        userAvatar: old.userAvatar,
                        mealSelections: [mealSelection],
                        hasSubmitted: true,
                        submittedAt: DateTime.now(),
                      );
                    } else {
                      updatedParticipants.add(GroupOrderParticipant(
                        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                        userId: 'u_client_1',
                        userName: 'Alex Morgan',
                        department: 'Engineering',
                        mealSelections: [mealSelection],
                        hasSubmitted: true,
                        submittedAt: DateTime.now(),
                      ));
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
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Meal "${meal.name}" submitted to group order "${activeGroupOrder.name}"!'),
                    backgroundColor: AppColors.oliveGreen,
                  ));
                },
              )
            : AppButton(
                label: 'Add to cart',
                icon: Icons.add_shopping_cart_rounded,
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(CartItem(
                    mealId: meal.id,
                    mealName: meal.name,
                    mealImageUrl: meal.imageUrl,
                    unitPrice: meal.price,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${meal.name} added to cart!'),
                    backgroundColor: AppColors.oliveGreen,
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'VIEW CART',
                      textColor: Colors.white,
                      onPressed: () => showCartSheet(context, ref),
                    ),
                  ));
                },
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(22),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.titleMd),
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.mutedText)),
        ],
      ),
    );
  }
}
