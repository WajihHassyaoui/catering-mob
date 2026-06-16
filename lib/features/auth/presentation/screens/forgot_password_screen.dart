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
import '../../../../shared/widgets/empty_state_widget.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await ref
        .read(authProvider.notifier)
        .forgotPassword(_emailCtrl.text.trim());
    if (mounted) {
      setState(() {
        _loading = false;
        _sent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: _sent ? _buildSuccess() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.oliveLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lock_reset_rounded,
                size: 32, color: AppColors.oliveGreen),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: AppSpacing.xl),
          Text('Forgot your password?', style: AppTypography.headingMd)
              .animate()
              .fade(delay: 150.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Enter the email address linked to your account and we'll send you a reset link.",
            style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
          ).animate().fade(delay: 250.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.xxl),
          AppTextField(
            label: 'Email Address',
            hint: 'you@email.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: AppValidators.email,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ).animate().fade(delay: 350.ms, duration: 300.ms),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: 'Send Reset Link',
            onPressed: _submit,
            isLoading: _loading,
          ).animate().fade(delay: 450.ms, duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmptyStateWidget(
          icon: Icons.mark_email_read_outlined,
          iconColor: AppColors.successGreen,
          title: 'Check your inbox',
          message:
              'We sent a password reset link to ${_emailCtrl.text.trim()}. Check your email and follow the instructions.',
          actionLabel: 'Back to Login',
          onAction: () => context.go('/login'),
        ),
      ],
    );
  }
}
