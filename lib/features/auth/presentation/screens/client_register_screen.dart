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
import '../providers/auth_provider.dart';

class ClientRegisterScreen extends ConsumerStatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  ConsumerState<ClientRegisterScreen> createState() =>
      _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends ConsumerState<ClientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _inviteCtrl = TextEditingController();
  bool _hasInviteCode = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _inviteCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).registerClient(
          fullName: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passCtrl.text,
          inviteCode: _hasInviteCode ? _inviteCtrl.text.trim() : null,
        );
    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (auth.isAuthenticated) context.go('/client');
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal Details', style: AppTypography.headingMd)
                  .animate()
                  .fade(duration: 300.ms),
              const SizedBox(height: 4),
              Text('Tell us a bit about yourself.',
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.mutedText))
                  .animate()
                  .fade(delay: 100.ms, duration: 300.ms),
              const SizedBox(height: AppSpacing.xxl),
              _field(
                  AppTextField(
                    label: 'Full Name',
                    hint: 'Alex Morgan',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: AppValidators.fullName,
                  ),
                  0),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Email Address',
                    hint: 'alex@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: AppValidators.email,
                  ),
                  1),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Phone Number',
                    hint: '+1 (555) 000-0000',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: AppValidators.phone,
                  ),
                  2),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Password',
                    controller: _passCtrl,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: AppValidators.password,
                  ),
                  3),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Confirm Password',
                    controller: _confirmCtrl,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: AppValidators.confirmPassword(_passCtrl.text),
                    textInputAction: TextInputAction.done,
                  ),
                  4),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Join a Company',
                                style: AppTypography.titleSm),
                            Text('Have an invite code?',
                                style: AppTypography.bodySm),
                          ],
                        ),
                        Switch(
                          value: _hasInviteCode,
                          onChanged: (v) => setState(() => _hasInviteCode = v),
                          activeThumbColor: AppColors.oliveGreen,
                          activeTrackColor: AppColors.oliveLight,
                        ),
                      ],
                    ),
                    if (_hasInviteCode) ...[
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Invite Code',
                        hint: 'TECH-LUNCH-42',
                        controller: _inviteCtrl,
                        prefixIcon: Icons.vpn_key_outlined,
                        validator:
                            _hasInviteCode ? AppValidators.inviteCode : null,
                      ),
                    ],
                  ],
                ),
              ).animate().fade(delay: 500.ms, duration: 300.ms),
              if (auth.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                _errorBanner(auth.error!),
              ],
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: 'Create Account',
                onPressed: _register,
                isLoading: auth.isLoading,
              ).animate().fade(delay: 600.ms, duration: 300.ms),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(
                  'By signing up you agree to our Terms & Privacy Policy.',
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(Widget field, int index) {
    return field
        .animate()
        .fade(delay: Duration(milliseconds: 200 + index * 80), duration: 300.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _errorBanner(String error) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.errorRed.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: AppColors.errorRed),
          const SizedBox(width: 8),
          Expanded(
            child: Text(error,
                style:
                    AppTypography.bodySm.copyWith(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }
}
