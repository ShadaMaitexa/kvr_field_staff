import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/base_bottom_nav_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/list_item_row.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Staff Home',
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
                'Welcome back,',
                style: AppTextStyles.bodyMedium,
              ),
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
                      value: '4',
                      icon: Icons.place_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatCard(
                      label: 'Tasks Done',
                      value: '2',
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
                      value: '3',
                      icon: Icons.pending_actions,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatCard(
                      label: 'Distance (km)',
                      value: '12.5',
                      icon: Icons.directions_car_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Mark Visit Button
              PrimaryButton(
                label: 'Mark Visit',
                onPressed: () {
                  context.go('/staff/mark-visit');
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Today's Visits Card
              Text(
                "Today's Visits",
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
                      title: 'Global Motors',
                      subtitle: '10:30 AM • 2.5 km',
                      avatarInitials: 'GM',
                      trailingBadge: const StatusBadge(status: 'Completed'),
                    ),
                    const Divider(height: 1),
                    ListItemRow(
                      title: 'Auto Tech Services',
                      subtitle: '12:15 PM • 5.1 km',
                      avatarInitials: 'AT',
                      trailingBadge: const StatusBadge(status: 'Completed'),
                    ),
                    const Divider(height: 1),
                    ListItemRow(
                      title: 'Sunrise Auto',
                      subtitle: 'Pending',
                      avatarInitials: 'SA',
                      trailingBadge: const StatusBadge(status: 'Pending'),
                    ),
                  ],
                ),
              ),
            ],
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