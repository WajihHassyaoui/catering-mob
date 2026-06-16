import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/group_order_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompanyGroupOrderDetailScreen extends ConsumerStatefulWidget {
  final String groupOrderId;

  const CompanyGroupOrderDetailScreen({
    super.key,
    required this.groupOrderId,
  });

  @override
  ConsumerState<CompanyGroupOrderDetailScreen> createState() =>
      _CompanyGroupOrderDetailScreenState();
}

class _CompanyGroupOrderDetailScreenState
    extends ConsumerState<CompanyGroupOrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the active group order
    final groupOrderIndex = MockData.groupOrders
        .indexWhere((go) => go.id == widget.groupOrderId);

    if (groupOrderIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order not found')),
        body: const Center(child: Text('Group order was not found.')),
      );
    }

    final groupOrder = MockData.groupOrders[groupOrderIndex];
    final submittedCount =
        groupOrder.participants.where((p) => p.hasSubmitted).length;
    final totalParticipants = groupOrder.participants.length;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(groupOrder.name,
            style: AppTypography.headingMd.copyWith(color: AppColors.charcoal)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.md,
            AppSpacing.pagePadding,
            AppSpacing.huge,
          ),
          children: [
            // 1. Overview Header Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.warmIvory,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.white.withAlpha(180)),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.ambientShadow,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusBadge.fromStatus(groupOrder.status,
                          size: BadgeSize.medium),
                      Text(
                        'Created by ${groupOrder.creatorName}',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 16, color: AppColors.oliveGreen),
                      const SizedBox(width: 8),
                      Text(
                        _formatFullDate(groupOrder.deliveryDate),
                        style: AppTypography.bodySm
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.schedule_outlined,
                          size: 16, color: AppColors.terracotta),
                      const SizedBox(width: 8),
                      Text(
                        groupOrder.deliveryTime,
                        style: AppTypography.bodySm
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.mutedText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          groupOrder.deliveryAddress,
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.mutedText),
                        ),
                      ),
                    ],
                  ),
                  if (groupOrder.joinCode != null) ...[
                    const Divider(height: 24, color: AppColors.softBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Invite Code', style: AppTypography.caption),
                            const SizedBox(height: 4),
                            Text(
                              groupOrder.joinCode!,
                              style: AppTypography.titleMd.copyWith(
                                  color: AppColors.oliveGreen,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: groupOrder.joinCode!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Invite code copied to clipboard!')),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.oliveGreen,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 2. Metrics Grid Dashboard
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    title: 'Submissions',
                    value: '$submittedCount / $totalParticipants',
                    subtitle: 'Team members submitted',
                    progress: totalParticipants > 0
                        ? submittedCount / totalParticipants
                        : 0,
                    color: AppColors.oliveGreen,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _MetricTile(
                    title: 'Capacity',
                    value:
                        '$totalParticipants / ${groupOrder.maxParticipants}',
                    subtitle: 'Invite limit slots filled',
                    progress: groupOrder.participantProgress,
                    color: AppColors.terracotta,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _FinancialTile(
              estimatedTotal: groupOrder.estimatedTotal ?? 0.0,
              paymentMethod: groupOrder.paymentMethod,
            ),
            const SizedBox(height: AppSpacing.sectionSpacing),

            // 3. Participant Selection List Section
            const SectionHeader(
              title: 'Team Selections',
              subtitle: 'Check what menu items each member has added.',
            ),
            const SizedBox(height: AppSpacing.md),
            if (groupOrder.participants.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.warmIvory,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.softBorder),
                ),
                child: Text(
                  'No team members have joined this group order yet.',
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.mutedText),
                ),
              )
            else
              ...groupOrder.participants.map(
                (participant) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ParticipantCard(participant: participant),
                ),
              ),
          ],
        ),
      ),
      // 4. Organizer Action Bottom Bar
      bottomNavigationBar: groupOrder.status != 'delivered' && groupOrder.status != 'closed'
          ? Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.md,
                AppSpacing.pagePadding,
                MediaQuery.of(context).padding.bottom + AppSpacing.md,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border:
                    Border(top: BorderSide(color: AppColors.softBorder)),
              ),
              child: AppButton(
                label: groupOrder.status == 'open'
                    ? 'Lock Group Order'
                    : 'Submit Order to Kitchen',
                icon: groupOrder.status == 'open'
                    ? Icons.lock_outline_rounded
                    : Icons.restaurant_menu_rounded,
                onPressed: () {
                  setState(() {
                    if (groupOrder.status == 'open') {
                      MockData.groupOrders[groupOrderIndex] =
                          groupOrder.copyWith(status: 'locked');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Group order is now LOCKED. No more menu selections can be added.'),
                          backgroundColor: AppColors.oliveGreen,
                        ),
                      );
                    } else if (groupOrder.status == 'locked') {
                      MockData.groupOrders[groupOrderIndex] =
                          groupOrder.copyWith(status: 'delivered');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Group order has been submitted to the kitchen!'),
                          backgroundColor: AppColors.oliveGreen,
                        ),
                      );
                    }
                  });
                },
              ),
            )
          : null,
    );
  }

  String _formatFullDate(DateTime d) {
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double progress;
  final Color color;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.titleLg.copyWith(color: color)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1).toDouble(),
              minHeight: 6,
              color: color,
              backgroundColor: color.withAlpha(22),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTypography.caption
                .copyWith(color: AppColors.mutedText, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FinancialTile extends StatelessWidget {
  final double estimatedTotal;
  final String paymentMethod;

  const _FinancialTile({
    required this.estimatedTotal,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.oliveGreen.withAlpha(22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.attach_money_rounded,
                    color: AppColors.oliveGreen, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estimated Spend', style: AppTypography.caption),
                  Text(
                    '\$${estimatedTotal.toStringAsFixed(2)}',
                    style: AppTypography.titleMd.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.charcoal.withAlpha(15),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              'Pay via ${paymentMethod.toUpperCase()}',
              style: AppTypography.labelSm.copyWith(color: AppColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final GroupOrderParticipant participant;

  const _ParticipantCard({required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Participant avatar and status badge
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.oliveLight,
                child: Text(
                  participant.initials,
                  style: AppTypography.labelMd
                      .copyWith(color: AppColors.oliveGreen, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(participant.userName, style: AppTypography.titleSm),
                    if (participant.department != null)
                      Text(
                        participant.department!,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.mutedText),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: participant.hasSubmitted
                      ? AppColors.oliveLight
                      : AppColors.terracotta.withAlpha(22),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      participant.hasSubmitted
                          ? Icons.check_circle_outline_rounded
                          : Icons.pending_actions_rounded,
                      size: 14,
                      color: participant.hasSubmitted
                          ? AppColors.oliveGreen
                          : AppColors.terracotta,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      participant.hasSubmitted ? 'Submitted' : 'Pending',
                      style: AppTypography.labelSm.copyWith(
                        color: participant.hasSubmitted
                            ? AppColors.oliveGreen
                            : AppColors.terracotta,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Row 2: Selected meals list
          if (participant.hasSubmitted && participant.mealSelections.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: AppColors.softBorder),
            ),
            ...participant.mealSelections.map(
              (selection) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selection.quantity}x  ${selection.mealName}',
                      style: AppTypography.bodySm
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${selection.subtotal.toStringAsFixed(2)}',
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
