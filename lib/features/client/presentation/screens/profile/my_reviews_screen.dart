import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/models/review_model.dart';
import '../../../../../shared/models/meal_model.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/profile_providers.dart';

class MyReviewsScreen extends ConsumerStatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends ConsumerState<MyReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    final reviews = ref.watch(reviewsProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.oliveGreen),
          onPressed: () => context.pop(),
        ),
        title: Text('My Reviews', style: AppTypography.headingMd.copyWith(color: AppColors.oliveGreen)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: reviews.isEmpty
            ? Center(
                child: Text('No reviews submitted yet.', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  100, // Leave space for FloatingActionButton
                ),
                itemCount: reviews.length,
                itemBuilder: (context, i) {
                  final rev = reviews[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.cardPadding),
                      decoration: BoxDecoration(
                        color: AppColors.warmIvory,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.white.withAlpha(180)),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.ambientShadow,
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(rev.mealName, style: AppTypography.titleSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${rev.createdAt.month}/${rev.createdAt.day}/${rev.createdAt.year}',
                                style: AppTypography.caption.copyWith(color: AppColors.mutedText),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(5, (starIdx) => Icon(
                                  starIdx < rev.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: AppColors.warmGold,
                                  size: 16,
                                )),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.edit_outlined, color: AppColors.mutedText, size: 18),
                                    onPressed: () => _showReviewFormSheet(context, review: rev),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.terracotta, size: 18),
                                    onPressed: () => _confirmDelete(context, rev),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            rev.comment,
                            style: AppTypography.bodySm.copyWith(color: AppColors.mutedText),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.oliveGreen,
        icon: const Icon(Icons.rate_review_outlined, color: Colors.white),
        label: const Text('Write Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showReviewFormSheet(context),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ReviewModel review) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Delete Review', style: AppTypography.headingMd),
        content: Text('Are you sure you want to delete your review for "${review.mealName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedText)),
          ),
          TextButton(
            onPressed: () {
              ref.read(reviewsProvider.notifier).deleteReview(review.id);
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.terracotta)),
          ),
        ],
      ),
    );
  }

  void _showReviewFormSheet(BuildContext context, {ReviewModel? review}) {
    final isEdit = review != null;
    final formKey = GlobalKey<FormState>();

    // Initial state setup
    MealModel? selectedMeal = isEdit
        ? MockMeals.meals.firstWhere((m) => m.id == review.mealId, orElse: () => MockMeals.meals.first)
        : (MockMeals.meals.isNotEmpty ? MockMeals.meals.first : null);

    int rating = review?.rating ?? 5;
    final commentController = TextEditingController(text: review?.comment ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.pagePadding,
                AppSpacing.pagePadding,
                MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isEdit ? 'Edit Review' : 'Write a Review', style: AppTypography.headingMd),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (isEdit) ...[
                        Text(
                          review.mealName,
                          style: AppTypography.titleMd.copyWith(color: AppColors.oliveGreen),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ] else ...[
                        Text('Select Meal to Review', style: AppTypography.caption),
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.warmIvory,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.softBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<MealModel>(
                              value: selectedMeal,
                              isExpanded: true,
                              dropdownColor: AppColors.creamBackground,
                              items: MockMeals.meals.map((meal) {
                                return DropdownMenuItem<MealModel>(
                                  value: meal,
                                  child: Text(meal.name, style: AppTypography.bodyMd),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setModalState(() {
                                  selectedMeal = val;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      Text('Rating', style: AppTypography.caption),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: List.generate(5, (index) {
                          final starVal = index + 1;
                          return IconButton(
                            padding: const EdgeInsets.only(right: 8),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              starVal <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: AppColors.warmGold,
                              size: 32,
                            ),
                            onPressed: () {
                              setModalState(() {
                                rating = starVal;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Comments / Review Details',
                        controller: commentController,
                        maxLines: 4,
                        prefixIcon: Icons.edit_note_rounded,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Please write some details' : null,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: isEdit ? 'Update Review' : 'Submit Review',
                        onPressed: () {
                          if (formKey.currentState!.validate() && selectedMeal != null) {
                            final newRev = ReviewModel(
                              id: review?.id ?? 'rev_${DateTime.now().millisecondsSinceEpoch}',
                              mealId: selectedMeal!.id,
                              mealName: selectedMeal!.name,
                              rating: rating,
                              comment: commentController.text.trim(),
                              createdAt: review?.createdAt ?? DateTime.now(),
                            );

                            if (isEdit) {
                              ref.read(reviewsProvider.notifier).updateReview(newRev);
                            } else {
                              ref.read(reviewsProvider.notifier).addReview(newRev);
                            }

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(isEdit ? 'Review updated successfully' : 'Review submitted successfully')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
