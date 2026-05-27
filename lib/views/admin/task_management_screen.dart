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

class TaskManagementScreen extends ConsumerWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminViewModelProvider);
    final allTasks = adminState.recentTasks;
    final pending = allTasks.where((t) => t.status == 'pending').toList();
    final completed =
        allTasks.where((t) => t.status == 'completed').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaseAppBar(
          title: 'Task Management',
          bottom: TabBar(
            labelColor: AppColors.teal,
            unselectedLabelColor: AppColors.navy.withValues(alpha: 0.5),
            indicatorColor: AppColors.teal,
            labelStyle: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'All (${allTasks.length})'),
              Tab(text: 'Pending (${pending.length})'),
              Tab(text: 'Done (${completed.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(allTasks, adminState, context),
            _buildTaskList(pending, adminState, context),
            _buildTaskList(completed, adminState, context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.teal,
          onPressed: () => context.push('/admin/assign-task'),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskList(
      List tasks, AdminState adminState, BuildContext context) {
    if (tasks.isEmpty) {
      return const EmptyState(
        icon: Icons.task_outlined,
        title: 'No tasks found',
        subtitle: 'Tap + to assign a new task.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final task = tasks[index];
        // Resolve assignee name
        final assignee = adminState.staffList
            .where((s) => s.id == task.assigneeId);
        final assigneeName =
            assignee.isNotEmpty ? assignee.first.name : 'Unassigned';

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: ListTile(
            title: Text(
              task.title,
              style: AppTextStyles.bodyLarge
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Assigned to: $assigneeName\nDue: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
            ),
            isThreeLine: true,
            trailing: StatusBadge(
              status: task.status == 'pending' ? 'Pending' : 'Completed',
            ),
          ),
        );
      },
    );
  }
}
