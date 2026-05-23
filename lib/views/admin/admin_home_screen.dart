import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/list_item_row.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Admin Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, ${user?.name ?? "Admin"}!',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2x2 Stat Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Total Visits',
                      value: '142',
                      icon: Icons.place_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatCard(
                      label: 'Active Staff',
                      value: '12',
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
                      value: '8',
                      icon: Icons.pending_actions,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatCard(
                      label: 'Total Distance',
                      value: '450 km',
                      icon: Icons.directions_car_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Staff Activity List
              Text(
                'Staff Activity',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  children: [
                    ListItemRow(
                      title: 'John Doe',
                      subtitle: 'Visits: 4 • 12 km',
                      avatarInitials: 'JD',
                      trailingBadge: const StatusBadge(status: 'Active'),
                    ),
                    const Divider(height: 1),
                    ListItemRow(
                      title: 'Jane Smith',
                      subtitle: 'Visits: 2 • 5 km',
                      avatarInitials: 'JS',
                      trailingBadge: const StatusBadge(status: 'Active'),
                    ),
                    const Divider(height: 1),
                    ListItemRow(
                      title: 'Mike Johnson',
                      subtitle: 'Visits: 0 • 0 km',
                      avatarInitials: 'MJ',
                      trailingBadge: const StatusBadge(status: 'Inactive'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
    );
  }
}