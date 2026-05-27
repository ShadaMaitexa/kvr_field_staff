import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/staff_viewmodel.dart';
import '../../widgets/list_item_row.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffState = ref.watch(staffViewModelProvider);
    final pending =
        staffState.tasks.where((t) => t.status == 'pending').toList();
    final completed =
        staffState.tasks.where((t) => t.status == 'completed').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Tasks',
              style:
                  AppTextStyles.titleMedium.copyWith(color: Colors.white)),
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.teal,
            indicatorWeight: 3,
            labelStyle: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Pending (${pending.length})'),
              Tab(text: 'Completed (${completed.length})'),
            ],
          ),
        ),
        body: SafeArea(
          child: staffState.isLoadingData
              ? const ShimmerLoading()
              : TabBarView(
                  children: [
                    // Pending Tab
                    pending.isEmpty
                        ? const EmptyState(
                            icon: Icons.task_outlined,
                            title: 'No pending tasks',
                            subtitle: 'All caught up!',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            itemCount: pending.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              final task = pending[index];
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd),
                                ),
                                child: ListItemRow(
                                  title: task.title,
                                  subtitle:
                                      'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                                  avatarInitials: task.title.isNotEmpty
                                      ? task.title
                                          .substring(0, 1)
                                          .toUpperCase()
                                      : 'T',
                                  trailingBadge:
                                      const StatusBadge(status: 'Pending'),
                                  onTap: () => context.push(
                                      '/staff/task-detail',
                                      extra: task),
                                ),
                              );
                            },
                          ),

                    // Completed Tab
                    completed.isEmpty
                        ? const EmptyState(
                            icon: Icons.task_alt,
                            title: 'No completed tasks',
                            subtitle:
                                'Completed tasks will appear here.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            itemCount: completed.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              final task = completed[index];
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd),
                                ),
                                child: ListItemRow(
                                  title: task.title,
                                  subtitle:
                                      'Done: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                                  avatarInitials: task.title.isNotEmpty
                                      ? task.title
                                          .substring(0, 1)
                                          .toUpperCase()
                                      : 'T',
                                  trailingBadge: const StatusBadge(
                                      status: 'Completed'),
                                ),
                              );
                            },
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
