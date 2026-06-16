import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/mock_data/mock_data.dart';
import '../../../../../shared/models/user_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/common_widgets.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/status_badge.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = MockData.members;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: members.isEmpty
            ? EmptyStateWidget(
                icon: Icons.people_outline_rounded,
                title: 'No members yet',
                message:
                    'Invite your team to unlock company ordering controls.',
                actionLabel: 'Invite members',
                onAction: () => context.push('/company/members/invite'),
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
                            Text('Members',
                                style: AppTypography.displayMedium
                                    .copyWith(fontSize: 34)),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '${members.length} employees linked to company ordering.',
                              style: AppTypography.bodyMd
                                  .copyWith(color: AppColors.mutedText),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        label: 'Invite',
                        icon: Icons.person_add_outlined,
                        fullWidth: false,
                        size: AppButtonSize.small,
                        onPressed: () =>
                            context.push('/company/members/invite'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _SearchPanel(),
                  const SizedBox(height: AppSpacing.sectionSpacing),
                  const SectionHeader(
                    title: 'Team directory',
                    subtitle: 'Spending limits and permissions at a glance.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...members.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: _MemberCard(
                              member: entry.value, index: entry.key),
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
            child: Text(
              'Search members, departments, or permissions',
              style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final CompanyMember member;
  final int index;

  const _MemberCard({required this.member, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = _avatarColor(index);
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
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: color,
                child: Text(member.initials,
                    style:
                        AppTypography.titleSm.copyWith(color: AppColors.white)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.fullName,
                        style: AppTypography.titleMd,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(
                      '${member.roleInCompany} - ${member.department}',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.mutedText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(member.email,
                        style: AppTypography.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              StatusBadge.fromStatus(member.status, size: BadgeSize.small),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              InfoPill(
                icon: Icons.payments_outlined,
                label: member.spendingLimit == null
                    ? 'No limit'
                    : '\$${member.spendingLimit!.toStringAsFixed(0)} limit',
                color: AppColors.terracotta,
              ),
              const SizedBox(width: AppSpacing.sm),
              InfoPill(
                icon: Icons.group_outlined,
                label: member.permissions.canCreateGroupOrders
                    ? 'Organizer'
                    : 'Participant',
                color: AppColors.oliveGreen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _PermissionToggle(
            label: 'Individual ordering',
            value: member.permissions.canPlaceIndividualOrders,
          ),
          _PermissionToggle(
            label: 'Create group orders',
            value: member.permissions.canCreateGroupOrders,
          ),
          _PermissionToggle(
            label: 'Catering requests',
            value: member.permissions.canRequestCatering,
          ),
        ],
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: index * 75), duration: 260.ms);
  }

  Color _avatarColor(int i) {
    const colors = [
      AppColors.oliveGreen,
      AppColors.terracotta,
      AppColors.warmGold,
      AppColors.sageGreen,
    ];
    return colors[i % colors.length];
  }
}

class _PermissionToggle extends StatelessWidget {
  final String label;
  final bool value;

  const _PermissionToggle({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission editing is coming soon.')),
        );
      },
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeThumbColor: AppColors.oliveGreen,
      activeTrackColor: AppColors.oliveLight,
      title: Text(label, style: AppTypography.bodySm),
    );
  }
}
