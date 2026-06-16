import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/choose_role_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/client_register_screen.dart';
import '../features/auth/presentation/screens/company_register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/pending_approval_screen.dart';
import '../features/client/presentation/navigation/client_navigation.dart';
import '../features/client/presentation/screens/profile/client_profile_screen.dart';
import '../features/client/presentation/screens/profile/edit_profile_screen.dart';
import '../features/client/presentation/screens/profile/my_addresses_screen.dart';
import '../features/client/presentation/screens/profile/favorite_meals_screen.dart';
import '../features/client/presentation/screens/profile/my_reviews_screen.dart';
import '../features/company/presentation/navigation/company_navigation.dart';
import '../features/client/presentation/screens/orders/track_order_screen.dart';
import '../features/client/presentation/screens/meals/meal_detail_screen.dart';
import '../features/company/presentation/screens/group_orders/company_group_order_detail_screen.dart';
import '../features/admin/presentation/navigation/admin_navigation.dart';
import '../core/constants/app_constants.dart';
import '../shared/mock_data/mock_data.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoading = authState.status == AuthStatus.loading;
      final loc = state.uri.path;

      if (isLoading) return null;

      final publicPaths = {
        '/splash',
        '/onboarding',
        '/choose-role',
        '/login',
        '/register/client',
        '/register/company',
        '/forgot-password',
      };

      if (!isAuthenticated && !publicPaths.contains(loc)) return '/login';

      if (isAuthenticated) {
        if (publicPaths.contains(loc)) {
          final role = authState.user?.role;
          if (role == AppConstants.roleAdmin) return '/admin';
          if (role == AppConstants.roleCompany) {
            final companyId = authState.user?.companyId;
            final company = companyId != null
                ? MockData.allCompanies
                    .where((c) => c.id == companyId)
                    .firstOrNull
                : null;
            if (company?.isPending == true) return '/pending-approval';
            return '/company';
          }
          return '/client';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(
          path: '/choose-role', builder: (_, __) => const ChooseRoleScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
          path: '/register/client',
          builder: (_, __) => const ClientRegisterScreen()),
      GoRoute(
          path: '/register/company',
          builder: (_, __) => const CompanyRegisterScreen()),
      GoRoute(
          path: '/forgot-password',
          builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(
          path: '/pending-approval',
          builder: (_, __) => const PendingApprovalScreen()),
      ShellRoute(
        builder: (_, __, child) => child,
        routes: [
          GoRoute(
            path: '/client',
            builder: (_, __) => const ClientNavigation(),
            routes: [
              GoRoute(
                path: 'meals/:id',
                builder: (_, state) => MealDetailScreen(
                  mealId: state.pathParameters['id'] ?? '',
                ),
              ),
              GoRoute(
                path: 'orders/:id/track',
                builder: (_, state) => TrackOrderScreen(
                  orderId: state.pathParameters['id'] ?? '',
                ),
              ),
              GoRoute(
                path: 'profile/edit',
                builder: (_, __) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'profile/addresses',
                builder: (_, __) => const MyAddressesScreen(),
              ),
              GoRoute(
                path: 'profile/favorites',
                builder: (_, __) => const FavoriteMealsScreen(),
              ),
              GoRoute(
                path: 'profile/reviews',
                builder: (_, __) => const MyReviewsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/company',
            builder: (_, __) => const CompanyNavigation(),
            routes: [
              GoRoute(
                path: 'catering/:id',
                builder: (_, state) => _PlaceholderScreen(
                    'Catering: ${state.pathParameters['id']}'),
              ),
              GoRoute(
                path: 'group-orders/:id',
                builder: (_, state) => CompanyGroupOrderDetailScreen(
                  groupOrderId: state.pathParameters['id'] ?? '',
                ),
              ),
              GoRoute(
                path: 'invoices/:id',
                builder: (_, state) => _PlaceholderScreen(
                    'Invoice: ${state.pathParameters['id']}'),
              ),
              GoRoute(
                path: 'members/invite',
                builder: (_, __) => const _PlaceholderScreen('Invite Member'),
              ),
              GoRoute(
                path: 'profile',
                builder: (_, __) => const ClientProfileScreen(),
              ),
              GoRoute(
                path: 'profile/edit',
                builder: (_, __) => const EditProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/admin',
            builder: (_, __) => const AdminNavigation(),
            routes: [
              GoRoute(
                path: 'profile',
                builder: (_, __) => const ClientProfileScreen(),
              ),
              GoRoute(
                path: 'profile/edit',
                builder: (_, __) => const EditProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
