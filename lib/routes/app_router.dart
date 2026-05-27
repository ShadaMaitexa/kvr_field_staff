import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/company_model.dart';
import '../models/task_model.dart';
import '../models/visit_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../views/auth/login_screen.dart';
import '../views/staff/staff_home_screen.dart';
import '../views/staff/mark_visit_screen.dart';
import '../views/staff/visit_confirmed_screen.dart';
import '../views/staff/visit_history_screen.dart';
import '../views/staff/task_list_screen.dart';
import '../views/staff/task_detail_screen.dart';
import '../views/admin/admin_home_screen.dart';
import '../views/admin/visit_log_screen.dart';
import '../views/admin/visit_detail_screen.dart';
import '../views/admin/task_management_screen.dart';
import '../views/admin/assign_task_screen.dart';
import '../views/admin/staff_management_screen.dart';
import '../views/admin/add_staff_screen.dart';

import '../views/super_admin/super_admin_home_screen.dart';
import '../views/super_admin/add_company_screen.dart';
import '../views/super_admin/company_detail_screen.dart';
import '../views/super_admin/add_admin_screen.dart';
import '../views/super_admin/global_visit_view_screen.dart';
import '../views/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _RiverpodRouterRefreshListenable(ref),
    redirect: (context, state) {
      final isInitialized = authState.isInitialized;
      final isSplash = state.matchedLocation == '/splash';

      if (!isInitialized) {
        // Wait for auth initialization to complete (session checking)
        return isSplash ? null : '/splash';
      }

      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated) {
        // Redirect to login if user is not authenticated and is not already heading there
        return isLoggingIn ? null : '/login';
      }

      // If authenticated and on login screen or splash, redirect to role-based home screen
      if (isLoggingIn || isSplash) {
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
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) => const StaffHomeScreen(),
        routes: [
          GoRoute(
            path: 'mark-visit',
            builder: (context, state) => const MarkVisitScreen(),
          ),
          GoRoute(
            path: 'visit-confirmed',
            builder: (context, state) => const VisitConfirmedScreen(),
          ),
          GoRoute(
            path: 'visit-history',
            builder: (context, state) => const VisitHistoryScreen(),
          ),
          GoRoute(
            path: 'tasks',
            builder: (context, state) => const TaskListScreen(),
          ),
          GoRoute(
            path: 'task-detail',
            builder: (context, state) =>
                TaskDetailScreen(task: state.extra as TaskModel?),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminHomeScreen(),
        routes: [
          GoRoute(
            path: 'visit-log',
            builder: (context, state) => const VisitLogScreen(),
          ),
          GoRoute(
            path: 'visit-detail',
            builder: (context, state) =>
                VisitDetailScreen(visit: state.extra as VisitModel?),
          ),
          GoRoute(
            path: 'tasks',
            builder: (context, state) => const TaskManagementScreen(),
          ),
          GoRoute(
            path: 'assign-task',
            builder: (context, state) => const AssignTaskScreen(),
          ),
          GoRoute(
            path: 'staff',
            builder: (context, state) => const StaffManagementScreen(),
          ),
          GoRoute(
            path: 'add-staff',
            builder: (context, state) => const AddStaffScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/super-admin',
        builder: (context, state) => const SuperAdminHomeScreen(),
        routes: [
          GoRoute(
            path: 'add-company',
            builder: (context, state) => const AddCompanyScreen(),
          ),
          GoRoute(
            path: 'company-detail',
            builder: (context, state) =>
                CompanyDetailScreen(company: state.extra as CompanyModel?),
          ),
          GoRoute(
            path: 'add-admin',
            builder: (context, state) =>
                AddAdminScreen(company: state.extra as CompanyModel?),
          ),
          GoRoute(
            path: 'global-visits',
            builder: (context, state) => const GlobalVisitViewScreen(),
          ),
        ],
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
