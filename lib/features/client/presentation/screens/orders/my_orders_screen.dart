import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class MyOrdersScreen extends ConsumerStatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  ConsumerState<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends ConsumerState<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = MockData.orders;
    final active = allOrders.where((o) => o.isActive).toList();
    final past = allOrders.where((o) => !o.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.xl,
                AppSpacing.pagePadding,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orders',
                      style:
                          AppTypography.displayMedium.copyWith(fontSize: 34)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Track the kitchen, delivery, and invoice trail.',
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.warmIvory,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.softBorder),
                    ),
                    child: TabBar(
                      controller: _tabs,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppColors.oliveGreen,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.mutedText,
                      labelStyle: AppTypography.labelLg,
                      tabs: const [
                        Tab(text: 'Active'),
                        Tab(text: 'Past'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _OrderList(
                      orders: active,
                      emptyMessage:
                          'No active orders. Browse the menu when lunch calls.'),
                  _OrderList(
                      orders: past,
                      emptyMessage: 'Past orders will appear after delivery.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final String emptyMessage;

  const _OrderList({required this.orders, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'No orders',
        message: emptyMessage,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.huge,
      ),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (_, i) => _OrderCard(order: orders[i], index: i),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final int index;

  const _OrderCard({required this.order, required this.index});

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
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.oliveLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(_statusIcon(order.status),
                    color: AppColors.oliveGreen),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderNumber, style: AppTypography.titleMd),
                    Text(
                      '${_formatDate(order.createdAt)} - ${order.totalItems} items',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromStatus(order.status, size: BadgeSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _MiniTimeline(status: order.status),
          const SizedBox(height: AppSpacing.lg),
          ...order.items.take(3).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.oliveGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          '${item.quantity} x ${item.mealName}',
                          style: AppTypography.bodySm,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.charcoal),
                      ),
                    ],
                  ),
                ),
              ),
          if (order.items.length > 3)
            Text('+${order.items.length - 3} more items',
                style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              InfoPill(
                icon: order.paymentMethod == 'invoice'
                    ? Icons.description_outlined
                    : Icons.credit_card_rounded,
                label: order.paymentMethod == 'invoice'
                    ? 'Company invoice'
                    : 'Card',
                color: AppColors.warmGold,
              ),
              const Spacer(),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style:
                    AppTypography.titleMd.copyWith(color: AppColors.terracotta),
              ),
            ],
          ),
          if (order.isActive) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Track order',
              icon: Icons.local_shipping_outlined,
              onPressed: () => context.push('/client/orders/${order.id}/track'),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 80), duration: 260.ms);
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'confirmed':
        return Icons.check_circle_outline_rounded;
      case 'preparing':
        return Icons.soup_kitchen_outlined;
      case 'out_for_delivery':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.check_circle_rounded;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _MiniTimeline extends StatelessWidget {
  final String status;

  const _MiniTimeline({required this.status});

  static const _steps = [
    'pending',
    'confirmed',
    'preparing',
    'out_for_delivery',
    'delivered'
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        _steps.indexOf(status).clamp(0, _steps.length - 1).toInt();
    return Row(
      children: List.generate(_steps.length, (i) {
        final completed = i <= currentIndex;
        final isLast = i == _steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 260 + i * 70),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: completed ? AppColors.oliveGreen : AppColors.softBeige,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: completed
                        ? AppColors.oliveGreen
                        : AppColors.lightBorder,
                  ),
                ),
                child: Icon(
                  completed ? Icons.check_rounded : Icons.circle_outlined,
                  size: 14,
                  color: completed ? AppColors.white : AppColors.mutedText,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 260 + i * 70),
                    height: 3,
                    color: i < currentIndex
                        ? AppColors.oliveGreen
                        : AppColors.lightBorder,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
