import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/group_order_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class ClientGroupOrdersScreen extends ConsumerWidget {
  const ClientGroupOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupOrders = MockData.groupOrders;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: groupOrders.isEmpty
            ? EmptyStateWidget(
                icon: Icons.group_outlined,
                title: 'No group orders',
                message:
                    'Join one with a company invite code when your team starts lunch.',
                actionLabel: 'Join with code',
                onAction: () => _showJoinDialog(context),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  AppSpacing.huge,
                ),
                children: [
                  Text('Group orders',
                      style:
                          AppTypography.displayMedium.copyWith(fontSize: 34)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Coordinate team meals without the spreadsheet energy.',
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _JoinCodePanel(onTap: () => _showJoinDialog(context)),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const SectionHeader(
                    title: 'Open invitations',
                    subtitle: 'Select your meal before the deadline closes.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...groupOrders.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: _GroupOrderCard(
                            groupOrder: entry.value,
                            index: entry.key,
                            onTap: () => _showGroupSheet(context, entry.value),
                          ),
                        ),
                      ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showJoinDialog(context),
        icon: const Icon(Icons.vpn_key_outlined),
        label: const Text('Join'),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Join group order', style: AppTypography.headingMd),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the invite code shared by your office manager.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Invite code',
              hint: 'TECH-LUNCH-42',
              controller: ctrl,
              prefixIcon: Icons.vpn_key_outlined,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Join',
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ctrl.text.trim().isEmpty
                              ? 'Enter a code to search for an order.'
                              : 'Looking for ${ctrl.text.trim()}...',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGroupSheet(BuildContext context, GroupOrder groupOrder) {
    AppBottomSheet.show(
      context,
      title: groupOrder.name,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          0,
          AppSpacing.pagePadding,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${groupOrder.participantCount} people joined. Deadline ${groupOrder.deadlineCountdown}.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.lg),
            StepProgressIndicator(
              totalSteps: 3,
              currentStep:
                  groupOrder.participants.any((p) => p.hasSubmitted) ? 3 : 1,
              labels: const ['Joined', 'Meal', 'Confirm'],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Select meal',
              icon: Icons.restaurant_menu_rounded,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinCodePanel extends StatelessWidget {
  final VoidCallback onTap;

  const _JoinCodePanel({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
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
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.oliveLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.vpn_key_rounded,
                  color: AppColors.oliveGreen),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Have an invite code?', style: AppTypography.titleMd),
                  Text(
                    'Join a company lunch in seconds.',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded,
                color: AppColors.oliveGreen),
          ],
        ),
      ),
    );
  }
}

class _GroupOrderCard extends StatelessWidget {
  final GroupOrder groupOrder;
  final int index;
  final VoidCallback onTap;

  const _GroupOrderCard({
    required this.groupOrder,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final submitted =
        groupOrder.participants.where((p) => p.hasSubmitted).length;
    final budgetProgress = (groupOrder.estimatedTotal ?? 0) / 1000;

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
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
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
                        style: AppTypography.titleMd,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        groupOrder.companyName ?? 'Company lunch',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(groupOrder.status,
                    size: BadgeSize.small),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InfoPill(
                    icon: Icons.calendar_today_outlined,
                    label: _formatDate(groupOrder.deliveryDate)),
                InfoPill(
                    icon: Icons.schedule_outlined,
                    label: groupOrder.deliveryTime,
                    color: AppColors.terracotta),
                InfoPill(
                    icon: Icons.timer_outlined,
                    label: groupOrder.deadlineCountdown,
                    color: AppColors.warmGold),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _ProgressRow(
              label: 'Meal selections',
              valueLabel: '$submitted/${groupOrder.participantCount}',
              value: groupOrder.participantCount == 0
                  ? 0
                  : submitted / groupOrder.participantCount,
              color: AppColors.oliveGreen,
            ),
            const SizedBox(height: AppSpacing.md),
            _ProgressRow(
              label: 'Spending limit',
              valueLabel:
                  '\$${(groupOrder.estimatedTotal ?? 0).toStringAsFixed(0)} est.',
              value: budgetProgress.clamp(0, 1).toDouble(),
              color: AppColors.terracotta,
            ),
            if (groupOrder.joinCode != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.oliveLight,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Code ${groupOrder.joinCode}',
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.oliveGreen),
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 80), duration: 260.ms);
  }

  String _formatDate(DateTime d) {
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
    return '${months[d.month - 1]} ${d.day}';
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double value;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.caption),
            Text(valueLabel,
                style: AppTypography.caption
                    .copyWith(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            minHeight: 6,
            value: value,
            color: color,
            backgroundColor: color.withAlpha(22),
          ),
        ),
      ],
    );
  }
}
