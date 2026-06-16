import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/common_widgets.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Welcome to',
                    style: AppTypography.bodyLg
                        .copyWith(color: AppColors.mutedText))
                .animate()
                .fade(duration: 260.ms),
            Text('Platter Catering',
                    style: AppTypography.displayMedium.copyWith(fontSize: 38))
                .animate()
                .fade(delay: 90.ms, duration: 280.ms)
                .slideX(begin: -0.05, end: 0),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Choose the workspace that matches how you order, manage, or operate catering.',
              style: AppTypography.bodyLg.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _RoleCard(
              index: 0,
              icon: Icons.person_outline_rounded,
              title: 'Employee',
              subtitle:
                  'Order lunch, join group orders, manage dietary preferences, and track deliveries.',
              imageUrl:
                  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=700',
              color: AppColors.oliveGreen,
              onTap: () => context.push('/register/client'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _RoleCard(
              index: 1,
              icon: Icons.business_outlined,
              title: 'Company admin',
              subtitle:
                  'Invite employees, run team meals, book catering, and manage invoices.',
              imageUrl:
                  'https://images.unsplash.com/photo-1555244162-803834f70033?w=700',
              color: AppColors.terracotta,
              onTap: () => context.push('/register/company'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _RoleCard(
              index: 2,
              icon: Icons.admin_panel_settings_outlined,
              title: 'Operations admin',
              subtitle:
                  'Review companies, curate menus, track orders, and build catering quotes.',
              imageUrl:
                  'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=700',
              color: AppColors.warmGold,
              onTap: () => context.go('/login'),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.mutedText)),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text('Log in',
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.oliveGreen)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
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
        child: Row(
          children: [
            Stack(
              children: [
                PremiumImage(
                  imageUrl: imageUrl,
                  width: 96,
                  height: 106,
                  borderRadius: BorderRadius.circular(22),
                  icon: icon,
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleLg),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.mutedText),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.arrow_forward_rounded, color: color),
          ],
        ),
      ),
    )
        .animate()
        .fade(delay: Duration(milliseconds: 160 + index * 90), duration: 280.ms)
        .slideY(begin: 0.06, end: 0);
  }
}
