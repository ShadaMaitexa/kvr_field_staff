import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class CompanyDetailScreen extends StatelessWidget {
  const CompanyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Company Details',
        
      ),
      body: SingleChildScrollView(
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
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Global Motors',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Total Staff: 15', style: AppTextStyles.bodyMedium),
                    Text('Total Visits: 450', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Company Admins',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.navy.withValues(alpha: 0.1),
                      child: Text('A$index', style: const TextStyle(color: AppColors.navy)),
                    ),
                    title: Text(
                      'Admin Name $index',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('admin@globalmotors.com'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Delete admin
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () {},
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

