import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../navigation/company_navigation.dart';

class CompanyDashboardScreen extends ConsumerWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = MockData.approvedCompany;
    final groupOrders = MockData.groupOrders;
    final cateringRequests = MockData.cateringRequests;
    final invoices = MockData.invoices;
    final unpaidInvoices = invoices.where((i) => !i.isPaid).toList();
    final user = ref.watch(authProvider).user ?? MockData.companyUser;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: _Header(company: company, firstName: user.firstName)),
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
                  _MetricsGrid(
                    company: company,
                    groupOrders: groupOrders,
                    unpaidInvoices: unpaidInvoices,
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _SpendSummary(
                      company: company, invoicesDue: unpaidInvoices.length),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _QuickActions(ref: ref, context: context),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _ActiveGroupOrders(groupOrders: groupOrders, ref: ref),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _CateringSnapshot(requests: cateringRequests, ref: ref),
                  if (unpaidInvoices.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sectionSpacing),
                    _InvoiceAlert(unpaid: unpaidInvoices, ref: ref),
                  ],
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
  final dynamic company;
  final String firstName;

  const _Header({required this.company, required this.firstName});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(34),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.white.withAlpha(48)),
                ),
                child: Center(
                  child: Text(
                    company.initials,
                    style:
                        AppTypography.titleLg.copyWith(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name,
                        style: AppTypography.titleLg
                            .copyWith(color: AppColors.white)),
                    Text(
                      '${company.industry} - ${company.size}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.white.withAlpha(190)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(company.status, size: BadgeSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Good ${_greeting()}, $firstName',
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.white.withAlpha(205)),
          ),
          const SizedBox(height: 4),
          Text(
            'Your catering operations dashboard',
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.white,
              fontSize: 34,
              height: 1.08,
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: -0.03, end: 0);
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }
}

class _MetricsGrid extends StatelessWidget {
  final dynamic company;
  final List<dynamic> groupOrders;
  final List<dynamic> unpaidInvoices;

  const _MetricsGrid({
    required this.company,
    required this.groupOrders,
    required this.unpaidInvoices,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      DashboardStatCard(
        icon: Icons.payments_outlined,
        value: '\$${(company.monthlySpend / 1000).toStringAsFixed(1)}k',
        title: 'Monthly spend',
        color: AppColors.terracotta,
        subtitle: 'Within forecast',
        progress: 0.68,
      ),
      DashboardStatCard(
        icon: Icons.people_rounded,
        value: '${company.memberCount}',
        title: 'Active employees',
        color: AppColors.oliveGreen,
        subtitle: '8 departments',
        progress: 0.78,
      ),
      DashboardStatCard(
        icon: Icons.group_rounded,
        value: '${groupOrders.length}',
        title: 'Group orders',
        color: AppColors.sageGreen,
      ),
      DashboardStatCard(
        icon: Icons.receipt_long_outlined,
        value: '${unpaidInvoices.length}',
        title: 'Pending invoices',
        color: AppColors.warmGold,
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

class _SpendSummary extends StatelessWidget {
  final dynamic company;
  final int invoicesDue;

  const _SpendSummary({required this.company, required this.invoicesDue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.white.withAlpha(180)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Budget pulse', style: AppTypography.titleLg)),
              const InfoPill(
                  icon: Icons.trending_up_rounded,
                  label: 'Healthy',
                  color: AppColors.successGreen),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const LinearProgressIndicator(
              minHeight: 10,
              value: 0.68,
              color: AppColors.terracotta,
              backgroundColor: AppColors.terracottaLight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${company.monthlySpend.toStringAsFixed(0)} used',
                  style: AppTypography.bodySm),
              Text('$invoicesDue invoice${invoicesDue == 1 ? '' : 's'} pending',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.mutedText)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final WidgetRef ref;
  final BuildContext context;

  const _QuickActions({required this.ref, required this.context});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action(
          Icons.group_add_rounded,
          'Create group order',
          AppColors.oliveGreen,
          () => ref.read(companyNavIndexProvider.notifier).state = 2),
      _Action(
          Icons.event_available_rounded,
          'Book catering',
          AppColors.terracotta,
          () => ref.read(companyNavIndexProvider.notifier).state = 3),
      _Action(Icons.person_add_outlined, 'Invite member', AppColors.sageGreen,
          () => this.context.push('/company/members/invite')),
      _Action(Icons.receipt_long_outlined, 'View invoices', AppColors.warmGold,
          () => ref.read(companyNavIndexProvider.notifier).state = 4),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Fast actions',
          subtitle: 'The admin tasks your week tends to need.',
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.8,
          ),
          itemCount: actions.length,
          itemBuilder: (_, i) {
            final action = actions[i];
            return GestureDetector(
              onTap: action.onTap,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: action.color.withAlpha(18),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: action.color.withAlpha(34)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: action.color.withAlpha(28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(action.icon, color: action.color, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        action.label,
                        style: AppTypography.titleSm,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActiveGroupOrders extends StatelessWidget {
  final List<dynamic> groupOrders;
  final WidgetRef ref;

  const _ActiveGroupOrders({required this.groupOrders, required this.ref});

  @override
  Widget build(BuildContext context) {
    if (groupOrders.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Active group orders',
          subtitle: 'Participant progress and deadlines.',
          actionLabel: 'Manage',
          onAction: () => ref.read(companyNavIndexProvider.notifier).state = 2,
        ),
        const SizedBox(height: AppSpacing.md),
        ...groupOrders.take(2).map(
              (go) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _DashboardListCard(
                  icon: Icons.groups_rounded,
                  color: AppColors.oliveGreen,
                  title: go.name,
                  subtitle:
                      '${go.participantCount} participants - ${go.deadlineCountdown}',
                  badge:
                      StatusBadge.fromStatus(go.status, size: BadgeSize.small),
                  onTap: () => context.push('/company/group-orders/${go.id}'),
                ),
              ),
            ),
      ],
    );
  }
}

class _CateringSnapshot extends StatelessWidget {
  final List<dynamic> requests;
  final WidgetRef ref;

  const _CateringSnapshot({required this.requests, required this.ref});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) return const SizedBox.shrink();
    final req = requests.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Catering pipeline',
          subtitle: 'Upcoming event requests and quotes.',
          actionLabel: 'Open',
          onAction: () => ref.read(companyNavIndexProvider.notifier).state = 3,
        ),
        const SizedBox(height: AppSpacing.md),
        _DashboardListCard(
          icon: Icons.event_available_rounded,
          color: AppColors.terracotta,
          title: req.eventType,
          subtitle: '${req.numberOfGuests} guests - ${req.serviceType}',
          badge: StatusBadge.fromStatus(req.status, size: BadgeSize.small),
          onTap: () => context.push('/company/catering/${req.id}'),
        ),
      ],
    );
  }
}

class _InvoiceAlert extends StatelessWidget {
  final List<dynamic> unpaid;
  final WidgetRef ref;

  const _InvoiceAlert({required this.unpaid, required this.ref});

  @override
  Widget build(BuildContext context) {
    final total = unpaid.fold<double>(0, (sum, invoice) => sum + invoice.total);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.terracotta.withAlpha(44),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded,
              color: AppColors.white, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${total.toStringAsFixed(2)} due',
                    style: AppTypography.headingSm
                        .copyWith(color: AppColors.white)),
                Text(
                    '${unpaid.length} invoice${unpaid.length == 1 ? '' : 's'} need review',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.white.withAlpha(205))),
              ],
            ),
          ),
          AppButton(
            label: 'Review',
            fullWidth: false,
            variant: AppButtonVariant.ghost,
            onPressed: () =>
                ref.read(companyNavIndexProvider.notifier).state = 4,
          ),
        ],
      ),
    );
  }
}

class _DashboardListCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget badge;
  final VoidCallback onTap;

  const _DashboardListCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
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
              width: 48,
              height: 48,
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
            badge,
          ],
        ),
      ),
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _Action(this.icon, this.label, this.color, this.onTap);
}
