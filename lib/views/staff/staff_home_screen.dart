import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/staff_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/base_bottom_nav_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/list_item_row.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;
    final staffState = ref.watch(staffViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Staff Home',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(staffViewModelProvider.notifier).loadData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: staffState.isLoadingData
            ? const ShimmerLoading()
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(staffViewModelProvider.notifier).loadData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Welcome back,', style: AppTextStyles.bodyMedium),
                      Text(
                        user?.name ?? 'Staff Member',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 2x2 Stat Grid
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: 'Visits Today',
                              value: staffState.todayVisitCount.toString(),
                              icon: Icons.place_outlined,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: StatCard(
                              label: 'Tasks Done',
                              value: staffState.completedTaskCount.toString(),
                              icon: Icons.task_alt,
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
                              value: staffState.pendingTaskCount.toString(),
                              icon: Icons.pending_actions,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: StatCard(
                              label: 'Distance (km)',
                              value: staffState.totalDistanceKm
                                  .toStringAsFixed(1),
                              icon: Icons.directions_car_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Mark Visit Button
                      PrimaryButton(
                        label: 'Mark Visit',
                        onPressed: () => context.go('/staff/mark-visit'),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Today's Visits
                      Text("Today's Visits", style: AppTextStyles.titleMedium),
                      const SizedBox(height: AppSpacing.sm),

                      if (staffState.visits.isEmpty)
                        const EmptyState(
                          icon: Icons.place_outlined,
                          title: 'No visits today',
                          subtitle: 'Tap "Mark Visit" to record your first visit.',
                        )
                      else
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: staffState.visits.length > 5
                                ? 5
                                : staffState.visits.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final visit = staffState.visits[index];
                              return ListItemRow(
                                title: visit.locationName,
                                subtitle:
                                    '${visit.createdAt.hour}:${visit.createdAt.minute.toString().padLeft(2, '0')} • ${visit.distanceInKm?.toStringAsFixed(1) ?? '0.0'} km',
                                avatarInitials: visit.locationName.isNotEmpty
                                    ? visit.locationName
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : 'V',
                                trailingBadge:
                                    const StatusBadge(status: 'Completed'),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const BaseBottomNavBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            activeIcon: Icon(Icons.place),
            label: 'Visits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}