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
import '../../../../../shared/models/user_model.dart';

class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user ?? MockData.clientUser;
    final canPop = Navigator.canPop(context);

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
            if (canPop) ...[
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppColors.oliveGreen,
                  ),
                  Text(
                    'Profile',
                    style: AppTypography.headingMd,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _ProfileHero(user: user),
            const SizedBox(height: AppSpacing.sectionSpacing),
            _StatsRow(user: user),
            if (user.role == 'client') ...[
              const SizedBox(height: AppSpacing.sectionSpacing),
              const SectionHeader(
                title: 'Meal preferences',
                subtitle: 'Keep recommendations aligned with your routine.',
              ),
              const SizedBox(height: AppSpacing.md),
              _PreferenceCard(),
            ],
            if (user.role != 'admin') ...[
              const SizedBox(height: AppSpacing.sectionSpacing),
              SectionHeader(
                title: user.role == 'company' ? 'Company administration' : 'Company workspace',
              ),
              const SizedBox(height: AppSpacing.md),
              _CompanyCard(user: user),
            ],
            const SizedBox(height: AppSpacing.sectionSpacing),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: AppSpacing.md),
            _SettingsPanel(role: user.role),
            const SizedBox(height: AppSpacing.sectionSpacing),
            AppButton(
              label: 'Log out',
              variant: AppButtonVariant.ghost,
              icon: Icons.logout_rounded,
              onPressed: () => _confirmLogout(context, ref),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Platter Catering v1.0.0',
                style: AppTypography.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Log out', style: AppTypography.headingMd),
        content: Text(
          'Are you sure you want to leave this session?',
          style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
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
                  label: 'Log out',
                  variant: AppButtonVariant.danger,
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final dynamic user;

  const _ProfileHero({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.oliveGreen.withAlpha(50),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.white.withAlpha(36),
            child: Text(
              user.initials,
              style: AppTypography.headingMd.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: AppTypography.titleLg.copyWith(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email,
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.white.withAlpha(190)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(28),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.white.withAlpha(36)),
                  ),
                  child: Text(
                    user.companyId != null
                        ? 'TechFlow Solutions'
                        : 'Personal account',
                    style:
                        AppTypography.caption.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: AppColors.white),
          ),
        ],
      ),
    ).animate().fade(duration: 280.ms).slideY(begin: -0.03, end: 0);
  }
}

class _StatsRow extends StatelessWidget {
  final UserModel user;

  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final List<(String, String)> stats;

    if (user.role == 'company') {
      stats = [
        ('${MockData.approvedCompany.memberCount}', 'Team'),
        ('Active', 'Status'),
        ('${MockData.groupOrders.length}', 'Orders'),
      ];
    } else if (user.role == 'admin') {
      stats = [
        ('${MockData.allCompanies.length}', 'Companies'),
        ('Operations', 'Status'),
        ('Global', 'Console'),
      ];
    } else {
      stats = [
        ('12', 'Orders'),
        ('4.8', 'Rating'),
        ('3', 'Groups'),
      ];
    }
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
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final stat = entry.value;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(stat.$1,
                          style: AppTypography.headingMd
                              .copyWith(color: AppColors.oliveGreen)),
                      Text(stat.$2, style: AppTypography.caption),
                    ],
                  ),
                ),
                if (entry.key < stats.length - 1)
                  Container(width: 1, height: 34, color: AppColors.softBorder),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const preferences = [
      ('High Protein', Icons.fitness_center_rounded, AppColors.oliveGreen),
      ('Gluten-Free', Icons.spa_rounded, AppColors.sageGreen),
      ('Halal', Icons.verified_outlined, AppColors.terracotta),
      ('No Peanuts', Icons.warning_amber_rounded, AppColors.warmGold),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: preferences
                .map((item) =>
                    InfoPill(icon: item.$2, label: item.$1, color: item.$3))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Update preferences',
            icon: Icons.tune_rounded,
            variant: AppButtonVariant.outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final dynamic user;

  const _CompanyCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final isCompany = user.role == 'company';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isCompany ? AppColors.oliveLight : AppColors.terracottaLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              isCompany ? Icons.admin_panel_settings_rounded : Icons.business_rounded,
              color: isCompany ? AppColors.oliveGreen : AppColors.terracotta,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    isCompany
                        ? 'TechFlow Solutions'
                        : (user.companyId != null ? 'TechFlow Solutions' : 'Join a company'),
                    style: AppTypography.titleMd),
                Text(
                  isCompany
                      ? 'Company Workspace Admin'
                      : (user.companyId != null
                          ? 'Senior Engineer - Engineering'
                          : 'Enter an invite code to connect benefits.'),
                  style:
                      AppTypography.bodySm.copyWith(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded, color: AppColors.mutedText),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  final String role;

  const _SettingsPanel({required this.role});

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String, String, VoidCallback)> tiles;

    if (role == 'company') {
      tiles = [
        (
          Icons.people_outline_rounded,
          'Manage members',
          'Invite and manage team members',
          () => context.push('/company/members/invite'),
        ),
        (
          Icons.receipt_long_outlined,
          'Billing & Invoices',
          'View and download invoices',
          () {},
        ),
        (Icons.help_outline_rounded, 'Support', 'Get help from Platter', () {}),
        (Icons.policy_outlined, 'Privacy', 'Terms and policies', () {}),
      ];
    } else if (role == 'admin') {
      tiles = [
        (
          Icons.business_outlined,
          'Companies administration',
          'Approve and review company workspaces',
          () {},
        ),
        (
          Icons.restaurant_menu_outlined,
          'Menu editor',
          'Add, edit or disable menu items',
          () {},
        ),
        (Icons.help_outline_rounded, 'Support', 'System support tickets', () {}),
        (Icons.policy_outlined, 'Privacy & Rules', 'Global policies', () {}),
      ];
    } else {
      tiles = [
        (
          Icons.location_on_outlined,
          'Delivery addresses',
          'Office and saved locations',
          () {},
        ),
        (
          Icons.favorite_outline_rounded,
          'Favorite meals',
          'Fast reorder shortcuts',
          () {},
        ),
        (Icons.help_outline_rounded, 'Support', 'Get help from Platter', () {}),
        (Icons.policy_outlined, 'Privacy', 'Terms and policies', () {}),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.white.withAlpha(180)),
      ),
      child: Column(
        children: List.generate(tiles.length, (i) {
          final tile = tiles[i];
          return Column(
            children: [
              ListTile(
                onTap: tile.$4,
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.oliveLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(tile.$1, size: 19, color: AppColors.oliveGreen),
                ),
                title: Text(tile.$2, style: AppTypography.titleSm),
                subtitle: Text(tile.$3,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.mutedText),
              ),
              if (i < tiles.length - 1)
                const Divider(
                    height: 1, indent: 72, color: AppColors.softBorder),
            ],
          );
        }),
      ),
    );
  }
}
