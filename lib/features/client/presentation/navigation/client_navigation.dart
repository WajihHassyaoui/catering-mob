import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../screens/group_orders/client_group_orders_screen.dart';
import '../screens/home/client_home_screen.dart';
import '../screens/meals/meals_list_screen.dart';
import '../screens/orders/my_orders_screen.dart';
import '../screens/profile/client_profile_screen.dart';

final clientNavIndexProvider = StateProvider<int>((ref) => 0);

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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey(index),
          child: screens[index],
        ),
      ),
    );
  }
}
