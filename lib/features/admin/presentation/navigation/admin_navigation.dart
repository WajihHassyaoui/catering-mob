import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../screens/catering/admin_catering_screen.dart';
import '../screens/companies/companies_screen.dart';
import '../screens/dashboard/admin_dashboard_screen.dart';
import '../screens/meals/admin_meals_screen.dart';
import '../screens/orders/admin_orders_screen.dart';

final adminNavIndexProvider = StateProvider<int>((ref) => 0);

class AdminNavigation extends ConsumerWidget {
  const AdminNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(adminNavIndexProvider);

    final screens = [
      const AdminDashboardScreen(),
      const CompaniesScreen(),
      const AdminMealsScreen(),
      const AdminOrdersScreen(),
      const AdminCateringScreen(),
    ];

    return RoleBasedAppScaffold(
      bottomNavigationBar: PremiumBottomNavBar(
        currentIndex: index,
        activeColor: AppColors.oliveGreen,
        activeBackground: AppColors.oliveLight,
        items: const [
          PremiumNavItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard_rounded,
              label: 'Console'),
          PremiumNavItem(
              icon: Icons.business_outlined,
              activeIcon: Icons.business_rounded,
              label: 'Companies'),
          PremiumNavItem(
              icon: Icons.restaurant_menu_outlined,
              activeIcon: Icons.restaurant_menu_rounded,
              label: 'Menu'),
          PremiumNavItem(
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long_rounded,
              label: 'Orders'),
          PremiumNavItem(
              icon: Icons.event_outlined,
              activeIcon: Icons.event_rounded,
              label: 'Quotes'),
        ],
        onTap: (i) => ref.read(adminNavIndexProvider.notifier).state = i,
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
