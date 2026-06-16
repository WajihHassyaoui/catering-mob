import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/widgets/meal_card.dart';

class FavoriteMealsScreen extends StatefulWidget {
  const FavoriteMealsScreen({super.key});

  @override
  State<FavoriteMealsScreen> createState() => _FavoriteMealsScreenState();
}

class _FavoriteMealsScreenState extends State<FavoriteMealsScreen> {
  late List<MealModel> _favoriteMeals;

  @override
  void initState() {
    super.initState();
    _favoriteMeals = MockMeals.meals.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
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
        child: _favoriteMeals.isEmpty
            ? Center(
                child: Text('No favorite meals yet', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.xl),
                itemCount: _favoriteMeals.length,
                itemBuilder: (context, i) {
                  final meal = _favoriteMeals[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: MealCard(
                      meal: meal,
                      isFavorite: true,
                      onTap: () => context.push('/client/meals/${meal.id}'),
                      onToggleFavorite: () {
                        setState(() {
                          _favoriteMeals.removeAt(i);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${meal.name} removed from favorites')),
                        );
                      },
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${meal.name} added to order')),
                        );
                      },
                    ).animate().fade(delay: Duration(milliseconds: i * 50), duration: 250.ms),
                  );
                },
              ),
      ),
    );
  }
}
