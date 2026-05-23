import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Task Details',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Collect Documents',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.teal),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Due: 24 May 2026',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 20, color: AppColors.teal),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Assigned by: Admin User',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                      const Divider(height: AppSpacing.xl),
                      Text(
                        'Description',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Please collect the registration documents from Global Motors and verify the chassis number before returning to the office.',
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              PrimaryButton(
                label: 'Mark as Completed',
                onPressed: () {
                  // Mark as complete logic
                },
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  // Add note logic
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.navy),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'Add Note',
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.navy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
