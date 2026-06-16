import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/group_order_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class CompanyGroupOrdersScreen extends ConsumerWidget {
  const CompanyGroupOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupOrders = MockData.groupOrders.where((g) => g.companyId == MockData.approvedCompany.id).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: groupOrders.isEmpty
            ? EmptyStateWidget(
                icon: Icons.group_outlined,
                title: 'No group orders',
                message:
                    'Create your first team lunch order with a guided setup.',
                actionLabel: 'Start wizard',
                onAction: () => _showWizard(context),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xl,
                  AppSpacing.pagePadding,
                  AppSpacing.huge,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Group orders',
                                style: AppTypography.displayMedium
                                    .copyWith(fontSize: 34)),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Publish team lunches with clear deadlines and invite codes.',
                              style: AppTypography.bodyMd
                                  .copyWith(color: AppColors.mutedText),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        label: 'Create',
                        icon: Icons.add_rounded,
                        fullWidth: false,
                        size: AppButtonSize.small,
                        onPressed: () => _showWizard(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _WizardPreview(onTap: () => _showWizard(context)),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const SectionHeader(
                    title: 'Organizer board',
                    subtitle:
                        'Track participation, deadlines, and estimated spend.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...groupOrders.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: _CompanyGroupOrderCard(
                            groupOrder: entry.value,
                            index: entry.key,
                          ),
                        ),
                      ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWizard(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
      ),
    );
  }

  void _showWizard(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: 'Create group order',
      child: SingleChildScrollView(
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
              const StepProgressIndicator(
                totalSteps: 5,
                currentStep: 1,
                labels: ['Menu', 'Place', 'Time', 'Invite', 'Review'],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Start with a menu package', style: AppTypography.titleLg),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'The full wizard can connect to the backend later. This preview keeps the UX shape ready.',
                style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Continue setup',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _WizardPreview extends StatelessWidget {
  final VoidCallback onTap;

  const _WizardPreview({required this.onTap});

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
              color: AppColors.oliveGreen.withAlpha(48),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.white),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Guided lunch setup',
                    style:
                        AppTypography.titleLg.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const StepProgressIndicator(
              totalSteps: 5,
              currentStep: 1,
              labels: ['Menu', 'Place', 'Time', 'Invite', 'Review'],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyGroupOrderCard extends StatelessWidget {
  final GroupOrder groupOrder;
  final int index;

  const _CompanyGroupOrderCard({required this.groupOrder, required this.index});

  @override
  Widget build(BuildContext context) {
    final submitted =
        groupOrder.participants.where((p) => p.hasSubmitted).length;
    return GestureDetector(
      onTap: () => context.push('/company/group-orders/${groupOrder.id}'),
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
                      Text(groupOrder.name,
                          style: AppTypography.titleMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(
                        groupOrder.menuPackageName ?? 'Custom menu package',
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
                    icon: Icons.vpn_key_outlined,
                    label: groupOrder.joinCode ?? 'No code',
                    color: AppColors.warmGold),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _ProgressLine(
              label: 'Participants submitted',
              valueLabel: '$submitted/${groupOrder.participantCount}',
              value: groupOrder.participantCount > 0
                  ? submitted / groupOrder.participantCount
                  : 0,
              color: AppColors.oliveGreen,
            ),
            const SizedBox(height: AppSpacing.md),
            _ProgressLine(
              label: 'Capacity',
              valueLabel:
                  '${groupOrder.participantCount}/${groupOrder.maxParticipants}',
              value: groupOrder.participantProgress,
              color: AppColors.terracotta,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Deadline ${groupOrder.deadlineCountdown}',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText)),
                Text(
                  groupOrder.estimatedTotal == null
                      ? 'Draft estimate'
                      : '\$${groupOrder.estimatedTotal!.toStringAsFixed(2)}',
                  style: AppTypography.titleSm
                      .copyWith(color: AppColors.terracotta),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 90), duration: 260.ms);
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

class _ProgressLine extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double value;
  final Color color;

  const _ProgressLine({
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
            value: value.clamp(0, 1).toDouble(),
            backgroundColor: color.withAlpha(22),
            color: color,
          ),
        ),
      ],
    );
  }
}
