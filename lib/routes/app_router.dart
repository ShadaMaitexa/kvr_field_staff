import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../views/auth/login_screen.dart';
import '../views/staff/staff_home_screen.dart';
import '../views/admin/admin_home_screen.dart';
import '../views/super_admin/super_admin_home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _RiverpodRouterRefreshListenable(ref),
    redirect: (context, state) {
      final isInitialized = authState.isInitialized;
      if (!isInitialized) {
        // Wait for auth initialization to complete (session checking)
        return null;
      }

      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated) {
        // Redirect to login if user is not authenticated and is not already heading there
        return isLoggingIn ? null : '/login';
      }

      // If authenticated and on login screen, redirect to role-based home screen
      if (isLoggingIn) {
        final role = authState.userModel?.role;
        return _getDefaultRouteForRole(role);
      }

      // Role-based protection: Check access permission for specific paths
      final role = authState.userModel?.role;
      final path = state.matchedLocation;

      if (path.startsWith('/staff') && role != 'staff') {
        return _getDefaultRouteForRole(role);
      }
      if (path.startsWith('/admin') && role != 'admin') {
        return _getDefaultRouteForRole(role);
      }
      if (path.startsWith('/super-admin') && role != 'super_admin') {
        return _getDefaultRouteForRole(role);
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) => const StaffHomeScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminHomeScreen(),
      ),
      GoRoute(
        path: '/super-admin',
        builder: (context, state) => const SuperAdminHomeScreen(),
      ),
    ],
  );
});

String _getDefaultRouteForRole(String? role) {
  if (role == 'staff') return '/staff';
  if (role == 'admin') return '/admin';
  if (role == 'super_admin') return '/super-admin';
  return '/login';
}

class _RiverpodRouterRefreshListenable extends ChangeNotifier {
  _RiverpodRouterRefreshListenable(Ref ref) {
    ref.listen(authViewModelProvider, (_, __) {
      notifyListeners();
    });
  }
}
