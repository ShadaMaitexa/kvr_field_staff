import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(),
            _buildTaskList(),
            _buildTaskList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.teal,
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: ListTile(
            title: Text(
              'Visit Client $index',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('Assigned to: John Doe\nDue: 26 May 2026'),
            isThreeLine: true,
            trailing: Chip(
              label: Text(
                index % 2 == 0 ? 'Pending' : 'Done',
                style: AppTextStyles.bodySmall.copyWith(
                  color: index % 2 == 0 ? Colors.orange : Colors.green,
                ),
              ),
              backgroundColor: index % 2 == 0
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
            ),
          ),
        );
      },
    );
  }
}
