import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );

    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (auth.isAuthenticated && auth.user != null) {
      switch (auth.user!.role) {
        case 'client':
          context.go('/client');
        case 'company':
          context.go('/company');
        case 'admin':
          context.go('/admin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.go('/onboarding'),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _LoginHero(),
            const SizedBox(height: AppSpacing.xxl),
            _DemoAccounts(onSelect: (email) => _emailCtrl.text = email),
            const SizedBox(height: AppSpacing.xxl),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Email address',
                    hint: 'you@company.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.email_outlined,
                    validator: AppValidators.email,
                  ).animate().fade(delay: 100.ms, duration: 260.ms),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'Password',
                    controller: _passCtrl,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Password is required.' : null,
                    onSubmitted: (_) => _login(),
                  ).animate().fade(delay: 170.ms, duration: 260.ms),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text('Forgot password?',
                          style: AppTypography.labelMd
                              .copyWith(color: AppColors.oliveGreen)),
                    ),
                  ),
                  if (auth.error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ErrorBanner(error: auth.error!),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Log in',
                    icon: Icons.login_rounded,
                    onPressed: _login,
                    isLoading: auth.isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: AppTypography.bodyMd
                              .copyWith(color: AppColors.mutedText)),
                      TextButton(
                        onPressed: () => context.go('/choose-role'),
                        child: Text('Sign up',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.oliveGreen)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.oliveGreen.withAlpha(48),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: PremiumImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1555244162-803834f70033?w=600',
              height: 110,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back',
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.white.withAlpha(205))),
                Text(
                  'Log in to Platter',
                  style:
                      AppTypography.headingLg.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Corporate catering, group meals, and operations in one polished workspace.',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.white.withAlpha(190)),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 280.ms).slideY(begin: -0.03, end: 0);
  }
}

class _DemoAccounts extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const _DemoAccounts({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final accounts = [
      ('Client', 'alex.morgan@email.com'),
      ('Company', 'admin@techflow.com'),
      ('Admin', 'admin@plattercatering.com'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 18, color: AppColors.warmGold),
              const SizedBox(width: AppSpacing.sm),
              Text('Demo access',
                  style: AppTypography.titleSm
                      .copyWith(color: AppColors.warmGold)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Password for all accounts: Password1',
              style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
          const SizedBox(height: AppSpacing.md),
          ...accounts.map(
            (account) => InkWell(
              onTap: () => onSelect(account.$2),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.goldLight,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(account.$1,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.warmGold),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(account.$2,
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.oliveGreen)),
                    ),
                    const Icon(Icons.touch_app_rounded,
                        size: 16, color: AppColors.mutedText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(delay: 80.ms, duration: 260.ms);
  }
}

class _ErrorBanner extends StatelessWidget {
  final String error;

  const _ErrorBanner({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.errorRed.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 18, color: AppColors.errorRed),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
              child: Text(error,
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.errorRed))),
        ],
      ),
    );
  }
}
