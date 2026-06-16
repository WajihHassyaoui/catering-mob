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

class CompanyRegisterScreen extends ConsumerStatefulWidget {
  const CompanyRegisterScreen({super.key});

  @override
  ConsumerState<CompanyRegisterScreen> createState() =>
      _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends ConsumerState<CompanyRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameCtrl = TextEditingController();
  final _adminNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String? _industry;
  String? _size;

  static const _industries = [
    'Technology',
    'Finance',
    'Healthcare',
    'Media & Marketing',
    'Education',
    'Real Estate',
    'Legal',
    'Consulting',
    'Retail',
    'Other',
  ];

  static const _sizes = [
    '1–10 employees',
    '11–50 employees',
    '51–200 employees',
    '201–500 employees',
    '500+ employees',
  ];

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _adminNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _websiteCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final user = await ref.read(authProvider.notifier).registerCompany(
          companyName: _companyNameCtrl.text.trim(),
          adminFullName: _adminNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          industry: _industry ?? '',
          size: _size ?? '',
          password: _passCtrl.text,
        );
    if (!mounted) return;
    if (user != null) context.go('/pending-approval');
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text('Register Company'),
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
              _sectionHeader('Company Information', Icons.business_outlined, 0),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Company Name',
                    hint: 'TechFlow Solutions',
                    controller: _companyNameCtrl,
                    prefixIcon: Icons.business_outlined,
                    validator: AppValidators.companyName,
                  ),
                  1),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppDropdown<String>(
                    label: 'Industry',
                    value: _industry,
                    hint: 'Select industry',
                    prefixIcon: Icons.category_outlined,
                    items: _industries
                        .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                        .toList(),
                    onChanged: (v) => setState(() => _industry = v),
                    validator: (v) =>
                        v == null ? 'Please select an industry.' : null,
                  ),
                  2),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppDropdown<String>(
                    label: 'Company Size',
                    value: _size,
                    hint: 'Number of employees',
                    prefixIcon: Icons.people_outline_rounded,
                    items: _sizes
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _size = v),
                    validator: (v) =>
                        v == null ? 'Please select company size.' : null,
                  ),
                  3),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Company Website',
                    hint: 'https://yourcompany.com',
                    controller: _websiteCtrl,
                    keyboardType: TextInputType.url,
                    prefixIcon: Icons.language_outlined,
                    validator: AppValidators.website,
                  ),
                  4),
              const SizedBox(height: AppSpacing.xxl),
              _sectionHeader(
                  'Admin Account', Icons.admin_panel_settings_outlined, 5),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Your Full Name',
                    hint: 'Jordan Lee',
                    controller: _adminNameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: AppValidators.fullName,
                  ),
                  6),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Work Email',
                    hint: 'you@yourcompany.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: AppValidators.email,
                  ),
                  7),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Phone Number',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: AppValidators.phone,
                  ),
                  8),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Password',
                    controller: _passCtrl,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: AppValidators.password,
                  ),
                  9),
              const SizedBox(height: AppSpacing.lg),
              _field(
                  AppTextField(
                    label: 'Confirm Password',
                    controller: _confirmCtrl,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    textInputAction: TextInputAction.done,
                    validator: AppValidators.confirmPassword(_passCtrl.text),
                  ),
                  10),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.warmGold.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule_outlined,
                        color: AppColors.warmGold, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pending Approval',
                              style: AppTypography.titleSm
                                  .copyWith(color: AppColors.warmGold)),
                          const SizedBox(height: 2),
                          Text(
                            'Company accounts require admin approval before you can place orders. This typically takes 1–2 business days.',
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fade(delay: 800.ms, duration: 300.ms),
              if (auth.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(auth.error!,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.errorRed)),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: 'Submit for Approval',
                onPressed: _register,
                isLoading: auth.isLoading,
              ).animate().fade(delay: 900.ms, duration: 300.ms),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, int delay) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.oliveLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: AppColors.oliveGreen),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(title, style: AppTypography.titleLg),
      ],
    )
        .animate()
        .fade(delay: Duration(milliseconds: delay * 60), duration: 300.ms);
  }

  Widget _field(Widget field, int index) {
    return field
        .animate()
        .fade(delay: Duration(milliseconds: 100 + index * 60), duration: 300.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
