import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../../../../shared/models/user_model.dart';
import '../../../../../shared/utils/file_picker_helper.dart';

ImageProvider? _getAvatarImage(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http')) {
    return NetworkImage(url);
  }
  if (url.startsWith('data:image/')) {
    try {
      final base64Content = url.split(',').last;
      return MemoryImage(base64Decode(base64Content));
    } catch (_) {
      return null;
    }
  }
  return null;
}


class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.oliveGreen),
          onPressed: () => context.pop(),
        ),
        title: Text('Edit Profile', style: AppTypography.headingMd.copyWith(color: AppColors.oliveGreen)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.xl),
            children: [
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: GestureDetector(
                  onTap: () => _showAvatarPicker(context, ref, user),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.oliveLight,
                        backgroundImage: _getAvatarImage(user?.avatarUrl),
                        child: _getAvatarImage(user?.avatarUrl) != null
                            ? null
                            : Text(
                                user?.initials ?? '?',
                                style: AppTypography.displayMedium.copyWith(color: AppColors.oliveGreen, fontSize: 32),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.oliveGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_outlined, color: AppColors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: 'Full Name',
                controller: _nameController,
                prefixIcon: Icons.person_outline_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xxl * 1.5),
              AppButton(
                label: 'Save Changes',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (user != null) {
                      final updatedUser = user.copyWith(
                        fullName: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        phone: _phoneController.text.trim(),
                      );
                      ref.read(authProvider.notifier).updateUser(updatedUser);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully!')),
                      );
                      context.pop();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context, WidgetRef ref, UserModel? user) {
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile Picture', style: AppTypography.headingMd),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Upload from Device',
                  icon: Icons.photo_library_outlined,
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      final result = await FilePickerHelper.pickImage();
                      if (result != null) {
                        final bytes = result['bytes'] as Uint8List;
                        final name = result['name'] as String;
                        final base64String = base64Encode(bytes);
                        final extension = name.split('.').last.toLowerCase();
                        final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
                        final dataUrl = 'data:$mimeType;base64,$base64String';
                        
                        final updatedUser = user.copyWith(avatarUrl: dataUrl);
                        ref.read(authProvider.notifier).updateUser(updatedUser);
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile picture uploaded successfully!')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to upload image: $e')),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Remove Photo',
                  variant: AppButtonVariant.ghost,
                  onPressed: () {
                    final updatedUser = user.copyWith(avatarUrl: '');
                    ref.read(authProvider.notifier).updateUser(updatedUser);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avatar removed.'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
