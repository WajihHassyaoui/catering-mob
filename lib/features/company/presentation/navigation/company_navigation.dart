import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../screens/billing/company_billing_screen.dart';
import '../screens/catering/company_catering_screen.dart';
import '../screens/dashboard/company_dashboard_screen.dart';
import '../screens/group_orders/company_group_orders_screen.dart';
import '../screens/members/members_screen.dart';

final companyNavIndexProvider = StateProvider<int>((ref) => 0);

class CompanyNavigation extends ConsumerWidget {
  const CompanyNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(companyNavIndexProvider);

    const screens = [
      CompanyDashboardScreen(),
      MembersScreen(),
      CompanyGroupOrdersScreen(),
      CompanyCateringScreen(),
      CompanyBillingScreen(),
    ];

    return RoleBasedAppScaffold(
      bottomNavigationBar: PremiumBottomNavBar(
        currentIndex: index,
        activeColor: AppColors.terracotta,
        activeBackground: AppColors.terracottaLight,
        items: const [
          PremiumNavItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard_rounded,
              label: 'Home'),
          PremiumNavItem(
              icon: Icons.people_outline_rounded,
              activeIcon: Icons.people_rounded,
              label: 'Team'),
          PremiumNavItem(
              icon: Icons.group_outlined,
              activeIcon: Icons.group_rounded,
              label: 'Orders'),
          PremiumNavItem(
              icon: Icons.event_outlined,
              activeIcon: Icons.event_rounded,
              label: 'Events'),
          PremiumNavItem(
              icon: Icons.receipt_outlined,
              activeIcon: Icons.receipt_rounded,
              label: 'Billing'),
        ],
        onTap: (i) => ref.read(companyNavIndexProvider.notifier).state = i,
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
