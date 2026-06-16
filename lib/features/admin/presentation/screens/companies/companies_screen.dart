import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/company_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = MockData.allCompanies;
    final pending = companies.where((c) => c.isPending).length;

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
            Text('Companies',
                style: AppTypography.displayMedium.copyWith(fontSize: 34)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$pending pending approvals across ${companies.length} company accounts.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SearchPanel(),
            const SizedBox(height: AppSpacing.sectionSpacing),
            ...companies.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _CompanyCard(company: entry.value, index: entry.key),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
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
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.oliveLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                const Icon(Icons.search_rounded, color: AppColors.oliveGreen),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text('Search company name, industry, or status',
                style:
                    AppTypography.bodyMd.copyWith(color: AppColors.mutedText)),
          ),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final int index;

  const _CompanyCard({required this.company, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
            color: company.isPending
                ? AppColors.warmGold.withAlpha(70)
                : AppColors.white.withAlpha(180)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: company.isPending
                      ? AppColors.warmGradient
                      : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                    child: Text(company.initials,
                        style: AppTypography.titleMd
                            .copyWith(color: AppColors.white))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: AppTypography.titleMd),
                    Text('${company.industry} - ${company.size}',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.mutedText)),
                  ],
                ),
              ),
              StatusBadge.fromStatus(company.status, size: BadgeSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              InfoPill(
                  icon: Icons.people_outline_rounded,
                  label: '${company.memberCount} members'),
              const SizedBox(width: AppSpacing.sm),
              InfoPill(
                icon: Icons.payments_outlined,
                label:
                    '\$${(company.monthlySpend / 1000).toStringAsFixed(1)}k/mo',
                color: AppColors.terracotta,
              ),
            ],
          ),
          if (company.isPending) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Reject',
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.small,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    label: 'Approve',
                    size: AppButtonSize.small,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 80), duration: 260.ms);
  }
}
