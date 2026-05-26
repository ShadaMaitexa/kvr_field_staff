import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Staff Management',
        
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: 4,
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
                child: Text('S$index', style: const TextStyle(color: AppColors.navy)),
              ),
              title: Text(
                'Staff Member $index',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Total Visits: ${10 * index}'),
              trailing: IconButton(
                icon: const Icon(Icons.block, color: Colors.red),
                onPressed: () {
                  // Deactivate staff
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () {},
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}

