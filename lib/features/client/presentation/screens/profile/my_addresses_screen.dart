import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/models/user_model.dart';
import '../../../../../shared/widgets/app_button.dart';

class MyAddressesScreen extends StatefulWidget {
  const MyAddressesScreen({super.key});

  @override
  State<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen> {
  final List<AddressModel> _addresses = [
    const AddressModel(
      id: 'addr_1',
      label: 'Office (Default)',
      street: '150 Tech Park Drive, Suite 400',
      city: 'San Francisco',
      state: 'CA',
      zip: '94105',
      isDefault: true,
    ),
    const AddressModel(
      id: 'addr_2',
      label: 'Home',
      street: '458 Oak Avenue',
      city: 'San Francisco',
      state: 'CA',
      zip: '94117',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.oliveGreen),
          onPressed: () => context.pop(),
        ),
        title: Text('My Addresses', style: AppTypography.headingMd.copyWith(color: AppColors.oliveGreen)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.xl),
          children: [
            ..._addresses.map((addr) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.warmIvory,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: addr.isDefault ? AppColors.oliveGreen : AppColors.white.withAlpha(180)),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.ambientShadow,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: addr.isDefault ? AppColors.oliveLight : AppColors.warmIvory,
                        shape: BoxShape.circle,
                        border: Border.all(color: addr.isDefault ? AppColors.oliveGreen : AppColors.softBorder),
                      ),
                      child: Icon(
                        addr.label.contains('Office') ? Icons.business_rounded : Icons.home_rounded,
                        color: addr.isDefault ? AppColors.oliveGreen : AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(addr.label, style: AppTypography.titleSm),
                          const SizedBox(height: 2),
                          Text(addr.fullAddress, style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.mutedText, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Add New Address',
              icon: Icons.add_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
