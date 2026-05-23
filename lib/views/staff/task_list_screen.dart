import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/list_item_row.dart';
import '../../widgets/status_badge.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Tasks', style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.teal,
            indicatorWeight: 3,
            labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              // Pending Tab
              ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const ListItemRow(
                      title: 'Collect Documents',
                      subtitle: 'Due: 24 May 2026',
                      avatarInitials: 'CD',
                      trailingBadge: StatusBadge(status: 'Pending'),
                    ),
                  );
                },
              ),
              
              // Completed Tab
              ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: 2,
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const ListItemRow(
                      title: 'Deliver Vehicle',
                      subtitle: 'Done: 23 May 2026',
                      avatarInitials: 'DV',
                      trailingBadge: StatusBadge(status: 'Completed'),
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
