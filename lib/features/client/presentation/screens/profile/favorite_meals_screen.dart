import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/meal_card.dart';
import '../../providers/client_providers.dart';
import '../../providers/profile_providers.dart';
import '../meals/cart_sheet.dart';


class FavoriteMealsScreen extends ConsumerWidget {
  const FavoriteMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.oliveGreen),
          onPressed: () => context.pop(),
        ),
        title: Text('Favorite Meals', style: AppTypography.headingMd.copyWith(color: AppColors.oliveGreen)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: favoriteMeals.isEmpty
            ? Center(
                child: Text('No favorite meals yet', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.xl),
                itemCount: favoriteMeals.length,
                itemBuilder: (context, i) {
                  final meal = favoriteMeals[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: MealCard(
                      meal: meal,
                      isFavorite: true,
                      onTap: () => context.push('/client/meals/${meal.id}'),
                      onToggleFavorite: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(meal);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${meal.name} removed from favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                  onAddToCart: () {
                        ref.read(cartProvider.notifier).addItem(
                          CartItem(
                            mealId: meal.id,
                            mealName: meal.name,
                            mealImageUrl: meal.imageUrl,
                            unitPrice: meal.price,
                          ),
                        );
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
                    ).animate().fade(delay: Duration(milliseconds: i * 50), duration: 250.ms),
                  );
                },
              ),
      ),
    );
  }
}
