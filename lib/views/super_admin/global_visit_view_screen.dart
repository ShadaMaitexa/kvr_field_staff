import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class GlobalVisitViewScreen extends StatelessWidget {
  const GlobalVisitViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Global Visits',
        
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Today'),
                    selected: true,
                    onSelected: (_) {},
                    selectedColor: AppColors.teal.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.teal,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilterChip(
                    label: const Text('This Week'),
                    selected: false,
                    onSelected: (_) {},
                    labelStyle: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilterChip(
                    label: const Text('This Month'),
                    selected: false,
                    onSelected: (_) {},
                    labelStyle: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: 10,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.navy.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(Icons.place, color: AppColors.teal),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Global Motors',
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.navy),
                              ),
                              Text(
                                'Staff: John Doe',
                                style: AppTextStyles.bodySmall,
                              ),
                              Text(
                                '10:30 AM • 26 May 2026',
                                style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

