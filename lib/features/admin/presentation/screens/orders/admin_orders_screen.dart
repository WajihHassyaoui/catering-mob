import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/order_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = MockData.orders;
    final statuses = [
      'pending',
      'confirmed',
      'preparing',
      'out_for_delivery',
      'delivered'
    ];

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
            Text('Order tracker',
                style: AppTypography.displayMedium.copyWith(fontSize: 34)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Kitchen and delivery status board for operations teams.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: DashboardStatCard(
                    icon: Icons.receipt_long_rounded,
                    value: '${orders.length}',
                    title: 'Total orders',
                    color: AppColors.oliveGreen,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DashboardStatCard(
                    icon: Icons.local_shipping_outlined,
                    value:
                        '${orders.where((o) => o.status == 'out_for_delivery').length}',
                    title: 'On route',
                    color: AppColors.terracotta,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),
            ...statuses.map((status) {
              final laneOrders =
                  orders.where((order) => order.status == status).toList();
              if (laneOrders.isEmpty) return const SizedBox.shrink();
              return _StatusLane(status: status, orders: laneOrders);
            }),
          ],
        ),
      ),
    );
  }
}

class _StatusLane extends StatelessWidget {
  final String status;
  final List<OrderModel> orders;

  const _StatusLane({required this.status, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: _label(status),
            subtitle: '${orders.length} order${orders.length == 1 ? '' : 's'}',
            trailing: StatusBadge.fromStatus(status, size: BadgeSize.small),
          ),
          const SizedBox(height: AppSpacing.md),
          ...orders.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _AdminOrderCard(order: entry.value, index: entry.key),
                ),
              ),
        ],
      ),
    );
  }

  String _label(String value) {
    switch (value) {
      case 'out_for_delivery':
        return 'Out for delivery';
      default:
        return value.replaceAll('_', ' ').split(' ').map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        }).join(' ');
    }
  }
}

class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  final int index;

  const _AdminOrderCard({required this.order, required this.index});

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
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.oliveLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.receipt_long_outlined,
                    color: AppColors.oliveGreen),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderNumber, style: AppTypography.titleMd),
                    Text(
                      order.companyName ?? order.userId,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text('\$${order.total.toStringAsFixed(2)}',
                  style: AppTypography.titleMd
                      .copyWith(color: AppColors.terracotta)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(
                  icon: Icons.inventory_2_outlined,
                  label: '${order.totalItems} items'),
              InfoPill(
                  icon: Icons.schedule_outlined,
                  label: _timeAgo(order.createdAt),
                  color: AppColors.warmGold),
              InfoPill(
                  icon: Icons.location_on_outlined,
                  label: order.deliveryTime ?? 'Today',
                  color: AppColors.terracotta),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: order.isDelivered ? 'Delivered' : 'Advance status',
            icon: order.isDelivered
                ? Icons.check_circle_outline_rounded
                : Icons.arrow_forward_rounded,
            size: AppButtonSize.small,
            onPressed: order.isDelivered ? null : () {},
          ),
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 60), duration: 240.ms);
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
