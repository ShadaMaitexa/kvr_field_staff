import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Visit History',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: 4, // Placeholder count
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
                          // Photo Thumbnail Placeholder
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.navy.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.navy.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          
                          // Visit Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Global Motors',
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: AppColors.teal),
                                    const SizedBox(width: 4),
                                    Text(
                                      '10:30 AM',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    const Icon(Icons.location_on, size: 14, color: AppColors.teal),
                                    const SizedBox(width: 4),
                                    Text(
                                      '10.0123, 76.3211',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
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
            
            // Total Distance Card at Bottom
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Distance Today',
                      style: AppTextStyles.titleMedium,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                      ),
                      child: Text(
                        '12.5 km',
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.teal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
