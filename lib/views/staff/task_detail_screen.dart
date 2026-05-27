import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/task_model.dart';
import '../../viewmodels/staff_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class TaskDetailScreen extends ConsumerWidget {
  final TaskModel? task;
  const TaskDetailScreen({super.key, this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use a fallback if task is null (direct route without extra)
    final t = task;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Task Details'),
      body: SafeArea(
        child: t == null
            ? const Center(child: Text('Task not found.'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.title,
                                style: AppTextStyles.titleLarge),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                    color: AppColors.teal),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Due: ${t.dueDate.day}/${t.dueDate.month}/${t.dueDate.year}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 20, color: AppColors.teal),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Status: ${t.status.toUpperCase()}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                            const Divider(height: AppSpacing.xl),
                            Text('Description',
                                style: AppTextStyles.titleMedium),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              t.description.isNotEmpty
                                  ? t.description
                                  : 'No description provided.',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (t.status == 'pending')
                      PrimaryButton(
                        label: 'Mark as Completed',
                        onPressed: () {
                          ref
                              .read(staffViewModelProvider.notifier)
                              .markTaskComplete(t.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    if (t.status == 'pending')
                      const SizedBox(height: AppSpacing.md),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.navy,
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: AppColors.navy),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                      ),
                      child: Text(
                        'Go Back',
                        style: AppTextStyles.buttonText
                            .copyWith(color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
