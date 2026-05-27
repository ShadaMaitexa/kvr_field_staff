import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/list_item_row.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;
    final adminState = ref.watch(adminViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Admin Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(adminViewModelProvider.notifier).loadDashboardData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: adminState.isLoading
            ? const ShimmerLoading()
            : RefreshIndicator(
                onRefresh: () => ref
                    .read(adminViewModelProvider.notifier)
                    .loadDashboardData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome, ${user?.name ?? "Admin"}!',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      if (adminState.error != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Text(
                            'Error: ${adminState.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      // 2x2 Stat Grid
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Total Visits',
                              value: adminState.recentVisits.length
                                  .toString(),
                              icon: Icons.place_outlined,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: StatCard(
                              label: 'Active Staff',
                              value: adminState.activeStaffCount.toString(),
                              icon: Icons.people_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Pending Tasks',
                              value: adminState.pendingTasks.toString(),
                              icon: Icons.pending_actions,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: StatCard(
                              label: 'Total Distance',
                              value:
                                  '${adminState.recentVisits.fold(0.0, (sum, item) => sum + (item.distanceInKm ?? 0)).toStringAsFixed(1)} km',
                              icon: Icons.directions_car_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Staff Activity List
                      Text('Staff Activity',
                          style: AppTextStyles.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      if (adminState.staffList.isEmpty)
                        const EmptyState(
                          icon: Icons.people_outline,
                          title: 'No staff found',
                          subtitle: 'Add staff members to get started.',
                        )
                      else
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: adminState.staffList.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final staff =
                                  adminState.staffList[index];
                              final visitCount = adminState
                                  .recentVisits
                                  .where(
                                      (v) => v.staffId == staff.id)
                                  .length;
                              return ListItemRow(
                                title: staff.name,
                                subtitle: 'Visits: $visitCount',
                                avatarInitials: staff.name.isNotEmpty
                                    ? staff.name
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : '?',
                                trailingBadge: StatusBadge(
                                    status: staff.status),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              context.go('/admin/visit-log');
              break;
            case 2:
              context.go('/admin/tasks');
              break;
            case 3:
              context.go('/admin/staff');
              break;
          }
        },
      ),
    );
  }
}