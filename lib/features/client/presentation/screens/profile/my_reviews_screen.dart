import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      (
        'Mediterranean Grain Bowl',
        5,
        'Absolutely delicious! The ingredients were fresh, and the portion size was perfect for lunch.',
        'June 12, 2026'
      ),
      (
        'Herb-Crusted Salmon',
        4,
        'Great texture and taste. The asparagus side was a bit salty, but overall very good.',
        'May 28, 2026'
      ),
    ];

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
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.xl),
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
                          child: Text(rev.$1, style: AppTypography.titleSm, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Text(rev.$4, style: AppTypography.caption.copyWith(color: AppColors.mutedText)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: List.generate(5, (starIdx) => Icon(
                        starIdx < rev.$2 ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: AppColors.warmGold,
                        size: 16,
                      )),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      rev.$3,
                      style: AppTypography.bodySm.copyWith(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
