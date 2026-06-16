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
import '../../../../../shared/widgets/meal_card.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../providers/client_providers.dart';

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user ?? MockData.clientUser;
    final featuredMeals = MockMeals.getFeaturedMeals();
    final activeOrders = MockData.orders.where((o) => o.isActive).toList();
    final groupOrders = MockData.groupOrders.where((g) => g.isOpen).toList();
    final mealPrepPlan =
        MockData.mealPrepPlans.isEmpty ? null : MockData.mealPrepPlans.first;
    final notifications =
        MockData.notifications.where((n) => !n.isRead).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroHeader(
              firstName: user.firstName,
              companyName: 'TechFlow Solutions',
              notificationCount: notifications.length,
              imageUrl: featuredMeals.firstOrNull?.imageUrl,
              onNotifications: () =>
                  _toast(context, 'Notifications are coming soon.'),
              onProfile: () =>
                  ref.read(clientNavIndexProvider.notifier).state = 4,
            ),
          ),
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
                  _SearchSurface(
                      onTap: () =>
                          ref.read(clientNavIndexProvider.notifier).state = 1),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  _QuickActions(ref: ref),
                  if (groupOrders.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sectionSpacing),
                    _GroupOrderSpotlight(
                      groupOrder: groupOrders.first,
                      onTap: () =>
                          ref.read(clientNavIndexProvider.notifier).state = 2,
                    ),
                  ],
                  if (mealPrepPlan != null) ...[
                    const SizedBox(height: AppSpacing.sectionSpacing),
                    _MealPrepCard(plan: mealPrepPlan),
                  ],
                  if (activeOrders.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sectionSpacing),
                    SectionHeader(
                      title: 'Today in motion',
                      subtitle: 'Track current deliveries and kitchen status.',
                      actionLabel: 'View orders',
                      onAction: () =>
                          ref.read(clientNavIndexProvider.notifier).state = 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...activeOrders.take(2).map(
                          (order) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _ActiveOrderCard(order: order),
                          ),
                        ),
                  ],
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  SectionHeader(
                    title: 'Chef recommendations',
                    subtitle: 'Fresh picks that travel well for office lunch.',
                    actionLabel: 'See menu',
                    onAction: () =>
                        ref.read(clientNavIndexProvider.notifier).state = 1,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 204,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredMeals.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (_, i) => MealCard(
                        meal: featuredMeals[i],
                        compact: true,
                        onTap: () => context
                            .push('/client/meals/${featuredMeals[i].id}'),
                      ).animate().fade(
                            delay: Duration(milliseconds: i * 70),
                            duration: 260.ms,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const SectionHeader(
                    title: 'Browse the pantry',
                    subtitle:
                        'Filter by lunch style, snacks, desserts, or drinks.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _CategoryGrid(
                      onTap: () =>
                          ref.read(clientNavIndexProvider.notifier).state = 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String firstName;
  final String companyName;
  final int notificationCount;
  final String? imageUrl;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const _HeroHeader({
    required this.firstName,
    required this.companyName,
    required this.notificationCount,
    required this.imageUrl,
    required this.onNotifications,
    required this.onProfile,
  });

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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(34),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.white.withAlpha(46)),
                ),
                child: const Icon(Icons.restaurant_rounded,
                    color: AppColors.white, size: 23),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platter Catering',
                      style: AppTypography.titleMd
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      companyName,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.white.withAlpha(190)),
                    ),
                  ],
                ),
              ),
              _HeaderIconButton(
                icon: Icons.notifications_outlined,
                badge: notificationCount,
                onTap: onNotifications,
              ),
              const SizedBox(width: AppSpacing.sm),
              _HeaderIconButton(
                icon: Icons.person_outline_rounded,
                onTap: onProfile,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${_greeting()}, $firstName',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.white,
                        fontSize: 34,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Curated meals, group lunches, and office-ready catering in one calm workspace.',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.white.withAlpha(205),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 112,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    PremiumImage(
                      imageUrl: imageUrl,
                      height: 118,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    Positioned(
                      right: -8,
                      bottom: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.deepShadow,
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          '12:30',
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.oliveGreen),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade(duration: 320.ms).slideY(begin: -0.04, end: 0);
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final int badge;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    this.badge = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.white.withAlpha(44)),
            ),
            child: Icon(icon, size: 21, color: AppColors.white),
          ),
          if (badge > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: AppColors.warmGold,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badge',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.charcoal,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchSurface extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchSurface({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warmIvory,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.white.withAlpha(180)),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ambientShadow,
              blurRadius: 22,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.oliveLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child:
                  const Icon(Icons.search_rounded, color: AppColors.oliveGreen),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Find lunch for today', style: AppTypography.titleSm),
                  Text(
                    'Bowls, salads, warm plates, drinks',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: AppColors.mutedText),
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: 90.ms, duration: 260.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

class _QuickActions extends StatelessWidget {
  final WidgetRef ref;

  const _QuickActions({required this.ref});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
          Icons.restaurant_menu_rounded,
          'Order',
          'New meal',
          AppColors.oliveGreen,
          () => ref.read(clientNavIndexProvider.notifier).state = 1),
      _QuickAction(
          Icons.group_rounded,
          'Join',
          'Group order',
          AppColors.terracotta,
          () => ref.read(clientNavIndexProvider.notifier).state = 2),
      _QuickAction(
          Icons.local_shipping_outlined,
          'Track',
          'Delivery',
          AppColors.warmGold,
          () => ref.read(clientNavIndexProvider.notifier).state = 3),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final action = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: entry.key == actions.length - 1 ? 0 : AppSpacing.md),
            child: GestureDetector(
              onTap: action.onTap,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warmIvory,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: action.color.withAlpha(28)),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.ambientShadow,
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: action.color.withAlpha(24),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(action.icon, color: action.color, size: 20),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(action.title, style: AppTypography.titleSm),
                    Text(
                      action.subtitle,
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fade(
              delay: Duration(milliseconds: 150 + entry.key * 70),
              duration: 260.ms,
            );
      }).toList(),
    );
  }
}

class _GroupOrderSpotlight extends StatelessWidget {
  final dynamic groupOrder;
  final VoidCallback onTap;

  const _GroupOrderSpotlight({required this.groupOrder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.oliveGreen.withAlpha(54),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.white.withAlpha(42)),
                  ),
                  child:
                      const Icon(Icons.groups_rounded, color: AppColors.white),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupOrder.name,
                        style: AppTypography.titleMd
                            .copyWith(color: AppColors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${groupOrder.participantCount} joined - ${groupOrder.deadlineCountdown}',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.white.withAlpha(195)),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(groupOrder.status,
                    size: BadgeSize.small),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                minHeight: 7,
                value: groupOrder.participantProgress,
                color: AppColors.warmGold,
                backgroundColor: AppColors.white.withAlpha(38),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Choose meal',
              onPressed: onTap,
              icon: Icons.arrow_forward_rounded,
              variant: AppButtonVariant.ghost,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 280.ms).slideY(begin: 0.08, end: 0);
  }
}

class _MealPrepCard extends StatelessWidget {
  final dynamic plan;

  const _MealPrepCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
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
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.terracottaLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: AppColors.terracotta),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: AppTypography.titleMd),
                    Text(
                      'Next delivery ${_dateLabel(plan.nextDelivery)}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(plan.status, size: BadgeSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(
                  icon: Icons.lunch_dining_rounded,
                  label: '${plan.mealsPerDay} meal/day'),
              InfoPill(
                  icon: Icons.payments_outlined,
                  label: '\$${plan.budget?.toStringAsFixed(0) ?? '0'} budget',
                  color: AppColors.terracotta),
              InfoPill(
                  icon: Icons.restaurant_rounded,
                  label: plan.mealTypes.join(', '),
                  color: AppColors.warmGold),
            ],
          ),
        ],
      ),
    ).animate().fade(delay: 120.ms, duration: 260.ms);
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return 'soon';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _ActiveOrderCard extends StatelessWidget {
  final dynamic order;

  const _ActiveOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/client/orders/${order.id}/track'),
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.oliveLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.local_shipping_outlined,
                  color: AppColors.oliveGreen),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderNumber, style: AppTypography.titleSm),
                  Text(
                    '${order.totalItems} items - ${order.deliveryTime ?? 'Today'} - \$${order.total.toStringAsFixed(2)}',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            StatusBadge.fromStatus(order.status, size: BadgeSize.small),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final VoidCallback onTap;

  const _CategoryGrid({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final categories = MockMeals.categories;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.18,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final category = categories[i];
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.warmIvory,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.white.withAlpha(180)),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.ambientShadow,
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: PremiumImage(
                    imageUrl: category.imageUrl,
                    height: 82,
                    borderRadius: BorderRadius.circular(16),
                    icon: Icons.restaurant_menu_rounded,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text(
                    category.name,
                    style: AppTypography.titleSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(
              delay: Duration(milliseconds: i * 55),
              duration: 240.ms,
            );
      },
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(
      this.icon, this.title, this.subtitle, this.color, this.onTap);
}
