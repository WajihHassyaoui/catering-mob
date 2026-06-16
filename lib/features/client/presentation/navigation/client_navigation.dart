import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../screens/group_orders/client_group_orders_screen.dart';
import '../screens/home/client_home_screen.dart';
import '../screens/meals/cart_sheet.dart';
import '../screens/meals/meals_list_screen.dart';
import '../screens/orders/my_orders_screen.dart';
import '../screens/profile/client_profile_screen.dart';
import '../providers/client_providers.dart';

class ClientNavigation extends ConsumerWidget {
  const ClientNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(clientNavIndexProvider);

    const screens = [
      ClientHomeScreen(),
      MealsListScreen(),
      ClientGroupOrdersScreen(),
      MyOrdersScreen(),
      ClientProfileScreen(),
    ];

    return RoleBasedAppScaffold(
      bottomNavigationBar: PremiumBottomNavBar(
        currentIndex: index,
        activeColor: AppColors.oliveGreen,
        activeBackground: AppColors.oliveLight,
        items: const [
          PremiumNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home'),
          PremiumNavItem(
              icon: Icons.restaurant_menu_outlined,
              activeIcon: Icons.restaurant_menu_rounded,
              label: 'Meals'),
          PremiumNavItem(
              icon: Icons.group_outlined,
              activeIcon: Icons.group_rounded,
              label: 'Group'),
          PremiumNavItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long_rounded,
              label: 'Orders'),
          PremiumNavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: 'Profile'),
        ],
        onTap: (i) => ref.read(clientNavIndexProvider.notifier).state = i,
      ),
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(index),
              child: screens[index],
            ),
          ),

          // ── Global Cart FAB — visible on every tab ─────────────────────────
          const Positioned(
            bottom: 16,
            right: 16,
            child: _GlobalCartFab(),
          ),
        ],
      ),
    );
  }
}

// ── Global Cart FAB ────────────────────────────────────────────────────────────

class _GlobalCartFab extends ConsumerWidget {
  const _GlobalCartFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final totalItems = cart.fold(0, (s, c) => s + c.quantity);

    if (totalItems == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => showCartSheet(context, ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.oliveGreen,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.oliveGreen.withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              '$totalItems item${totalItems > 1 ? 's' : ''}  ·  View Cart',
              style: AppTypography.labelMd.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          duration: 220.ms,
          curve: Curves.easeOutBack,
        );
  }
}
