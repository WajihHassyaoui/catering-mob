import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/mock_data/mock_meals.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = MockData.allCompanies;
    final orders = MockData.orders;
    final catering = MockData.cateringRequests;
    final pendingCompanies = companies.where((c) => c.isPending).toList();
    final grossSales =
        orders.fold<double>(0, (sum, order) => sum + order.total) +
            MockData.invoices
                .fold<double>(0, (sum, invoice) => sum + invoice.total);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(ref: ref)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.xl,
                AppSpacing.pagePadding,
                AppSpacing.huge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Metrics(
                    grossSales: grossSales,
                    pendingCompanies: pendingCompanies.length,
                    activeMenuItems:
                        MockMeals.meals.where((m) => m.isAvailable).length,
                    openQuotes:
                        catering.where((c) => c.isPending || c.isQuoted).length,
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  if (pendingCompanies.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Approval queue',
                      subtitle: 'Companies waiting for operations review.',
                      trailing: StatusBadge.fromStatus('pending',
                          size: BadgeSize.small),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...pendingCompanies.map(
                        (company) => _PendingCompanyCard(company: company)),
                    const SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                  const SectionHeader(
                    title: 'Operations feed',
                    subtitle:
                        'Recent orders and catering work that may need attention.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...orders.take(3).map(
                        (order) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _FeedCard(
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.oliveGreen,
                            title: order.orderNumber,
                            subtitle:
                                '${order.companyName ?? 'Individual'} - ${order.totalItems} items',
                            trailing: '\$${order.total.toStringAsFixed(2)}',
                            badge: StatusBadge.fromStatus(order.status,
                                size: BadgeSize.small),
                          ),
                        ),
                      ),
                  ...catering.take(2).map(
                        (request) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _FeedCard(
                            icon: Icons.event_available_rounded,
                            color: AppColors.terracotta,
                            title: request.eventType,
                            subtitle:
                                '${request.companyName ?? request.contactPerson} - ${request.numberOfGuests} guests',
                            trailing: request.quotedPrice == null
                                ? 'Quote'
                                : '\$${request.quotedPrice!.toStringAsFixed(0)}',
                            badge: StatusBadge.fromStatus(request.status,
                                size: BadgeSize.small),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final WidgetRef ref;

  const _Header({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        MediaQuery.of(context).padding.top + AppSpacing.lg,
        AppSpacing.pagePadding,
        AppSpacing.xxl,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(34),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.white.withAlpha(48)),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: AppColors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Operations console',
                    style: AppTypography.headingLg
                        .copyWith(color: AppColors.white)),
                Text('Live catering control center',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.white.withAlpha(190))),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout_rounded, color: AppColors.white),
          ),
        ],
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: -0.03, end: 0);
  }
}

class _Metrics extends StatelessWidget {
  final double grossSales;
  final int pendingCompanies;
  final int activeMenuItems;
  final int openQuotes;

  const _Metrics({
    required this.grossSales,
    required this.pendingCompanies,
    required this.activeMenuItems,
    required this.openQuotes,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      DashboardStatCard(
        icon: Icons.trending_up_rounded,
        value: '\$${grossSales.toStringAsFixed(0)}',
        title: 'Gross sales',
        color: AppColors.terracotta,
        subtitle: 'Demo total',
        progress: 0.72,
      ),
      DashboardStatCard(
        icon: Icons.pending_actions_rounded,
        value: '$pendingCompanies',
        title: 'Pending approvals',
        color: AppColors.warmGold,
      ),
      DashboardStatCard(
        icon: Icons.restaurant_menu_rounded,
        value: '$activeMenuItems',
        title: 'Active menu items',
        color: AppColors.oliveGreen,
      ),
      DashboardStatCard(
        icon: Icons.request_quote_outlined,
        value: '$openQuotes',
        title: 'Open quotes',
        color: AppColors.sageGreen,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.12,
      ),
      itemCount: metrics.length,
      itemBuilder: (_, i) => metrics[i],
    );
  }
}

class _PendingCompanyCard extends StatelessWidget {
  final dynamic company;

  const _PendingCompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.warmGold.withAlpha(60)),
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(company.initials,
                      style: AppTypography.titleMd
                          .copyWith(color: AppColors.warmGold)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: AppTypography.titleMd),
                    Text(
                      '${company.industry} - ${company.size}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String trailing;
  final Widget badge;

  const _FeedCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withAlpha(24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.titleSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(subtitle,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trailing,
                  style: AppTypography.titleSm
                      .copyWith(color: AppColors.terracotta)),
              const SizedBox(height: 5),
              badge,
            ],
          ),
        ],
      ),
    );
  }
}
