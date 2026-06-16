import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../shared/models/user_model.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../providers/profile_providers.dart';

class MyAddressesScreen extends ConsumerStatefulWidget {
  const MyAddressesScreen({super.key});

  @override
  ConsumerState<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends ConsumerState<MyAddressesScreen> {
  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(addressesProvider);

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
            if (addresses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    'No saved addresses yet.',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.mutedText),
                  ),
                ),
              )
            else
              ...addresses.map((addr) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: GestureDetector(
                  onTap: () {
                    ref.read(addressesProvider.notifier).setDefaultAddress(addr.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${addr.label} set as default address'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
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
                            addr.label.toLowerCase().contains('office') ? Icons.business_rounded : Icons.home_rounded,
                            color: addr.isDefault ? AppColors.oliveGreen : AppColors.mutedText,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      addr.label,
                                      style: AppTypography.titleSm,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (addr.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.oliveGreen,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'DEFAULT',
                                        style: AppTypography.caption.copyWith(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(addr.fullAddress, style: AppTypography.bodySm.copyWith(color: AppColors.mutedText)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.mutedText, size: 20),
                              onPressed: () => _showAddressFormSheet(context, address: addr),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.terracotta, size: 20),
                              onPressed: () => _confirmDelete(context, addr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Add New Address',
              icon: Icons.add_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => _showAddressFormSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressModel address) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text('Delete Address', style: AppTypography.headingMd),
        content: Text('Are you sure you want to delete "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedText)),
          ),
          TextButton(
            onPressed: () {
              ref.read(addressesProvider.notifier).deleteAddress(address.id);
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Deleted "${address.label}"')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.terracotta)),
          ),
        ],
      ),
    );
  }

  void _showAddressFormSheet(BuildContext context, {AddressModel? address}) {
    final isEdit = address != null;
    final formKey = GlobalKey<FormState>();

    final labelController = TextEditingController(text: address?.label ?? '');
    final streetController = TextEditingController(text: address?.street ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final zipController = TextEditingController(text: address?.zip ?? '');
    bool isDefaultValue = address?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.pagePadding,
                AppSpacing.pagePadding,
                MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(isEdit ? 'Edit Address' : 'Add New Address', style: AppTypography.headingMd),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Address Label (e.g. Home, Office)',
                        controller: labelController,
                        prefixIcon: Icons.label_outline_rounded,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a label' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Street Address',
                        controller: streetController,
                        prefixIcon: Icons.location_on_outlined,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Please enter street address' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'City',
                              controller: cityController,
                              validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              label: 'State',
                              controller: stateController,
                              validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'ZIP Code',
                        controller: zipController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.pin_drop_outlined,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SwitchListTile(
                        title: Text('Set as Default Address', style: AppTypography.titleSm),
                        value: isDefaultValue,
                        activeThumbColor: AppColors.oliveGreen,
                        activeTrackColor: AppColors.oliveGreen.withAlpha(128),
                        onChanged: (val) {
                          setModalState(() {
                            isDefaultValue = val;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: isEdit ? 'Save Changes' : 'Add Address',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final newAddr = AddressModel(
                              id: address?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
                              label: labelController.text.trim(),
                              street: streetController.text.trim(),
                              city: cityController.text.trim(),
                              state: stateController.text.trim(),
                              zip: zipController.text.trim(),
                              isDefault: isDefaultValue,
                            );

                            if (isEdit) {
                              ref.read(addressesProvider.notifier).updateAddress(newAddr);
                            } else {
                              ref.read(addressesProvider.notifier).addAddress(newAddr);
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(isEdit ? 'Address updated' : 'Address added')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
