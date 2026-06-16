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

class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user ?? MockData.clientUser;

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
            _ProfileHero(user: user),
            const SizedBox(height: AppSpacing.sectionSpacing),
            _StatsRow(),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const SectionHeader(
              title: 'Meal preferences',
              subtitle: 'Keep recommendations aligned with your routine.',
            ),
            const SizedBox(height: AppSpacing.md),
            _PreferenceCard(),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const SectionHeader(title: 'Company workspace'),
            const SizedBox(height: AppSpacing.md),
            _CompanyCard(user: user),
            const SizedBox(height: AppSpacing.sectionSpacing),
            const SectionHeader(title: 'Account'),
            const SizedBox(height: AppSpacing.md),
            _SettingsPanel(),
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
      builder: (_) => AlertDialog(
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Log out',
                  variant: AppButtonVariant.danger,
                  onPressed: () async {
                    Navigator.pop(context);
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
  @override
  Widget build(BuildContext context) {
    final stats = [
      ('12', 'Orders'),
      ('4.8', 'Rating'),
      ('3', 'Groups'),
    ];
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
              color: AppColors.terracottaLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child:
                const Icon(Icons.business_rounded, color: AppColors.terracotta),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    user.companyId != null
                        ? 'TechFlow Solutions'
                        : 'Join a company',
                    style: AppTypography.titleMd),
                Text(
                  user.companyId != null
                      ? 'Senior Engineer - Engineering'
                      : 'Enter an invite code to connect benefits.',
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
  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        Icons.location_on_outlined,
        'Delivery addresses',
        'Office and saved locations'
      ),
      (
        Icons.favorite_outline_rounded,
        'Favorite meals',
        'Fast reorder shortcuts'
      ),
      (Icons.help_outline_rounded, 'Support', 'Get help from Platter'),
      (Icons.policy_outlined, 'Privacy', 'Terms and policies'),
    ];

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
                onTap: () {},
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
