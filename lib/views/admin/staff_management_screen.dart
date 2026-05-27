import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

class StaffManagementScreen extends ConsumerWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminViewModelProvider);
    final staffList = adminState.staffList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Staff Management'),
      body: adminState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : staffList.isEmpty
              ? const EmptyState(
                  icon: Icons.people_outline,
                  title: 'No staff found',
                  subtitle: 'Tap + to add a new staff member.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: staffList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final staff = staffList[index];
                    final visitCount = adminState.recentVisits
                        .where((v) => v.staffId == staff.id)
                        .length;
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.navy.withValues(alpha: 0.1),
                          child: Text(
                            staff.name.isNotEmpty
                                ? staff.name
                                    .substring(0, 1)
                                    .toUpperCase()
                                : '?',
                            style:
                                const TextStyle(color: AppColors.navy),
                          ),
                        ),
                        title: Text(
                          staff.name,
                          style: AppTextStyles.bodyLarge
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Total Visits: $visitCount'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StatusBadge(status: staff.status),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                staff.status == 'active'
                                    ? Icons.block
                                    : Icons.check_circle_outline,
                                color: staff.status == 'active'
                                    ? AppColors.red
                                    : AppColors.green,
                              ),
                              onPressed: () {
                                ref
                                    .read(adminViewModelProvider.notifier)
                                    .toggleStaffStatus(
                                        staff.id, staff.status);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () => context.push('/admin/add-staff'),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
