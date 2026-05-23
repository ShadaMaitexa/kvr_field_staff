import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class VisitLogScreen extends StatelessWidget {
  const VisitLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Visit Logs',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filters
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by staff or location...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.navy.withValues(alpha: 0.5)),
                      prefixIcon: const Icon(Icons.search, color: AppColors.navy),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
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
                          label: const Text('Yesterday'),
                          selected: false,
                          onSelected: (_) {},
                          labelStyle: AppTextStyles.bodySmall,
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
                          label: const Text('Custom Date'),
                          selected: false,
                          onSelected: (_) {},
                          labelStyle: AppTextStyles.bodySmall,
                          avatar: const Icon(Icons.calendar_today, size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Visit List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: 4,
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
                          // Photo Thumbnail
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
                          
                          // Visit Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'John Doe',
                                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '10:30 AM',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: AppColors.teal),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Global Motors, Ernakulam',
                                        style: AppTextStyles.bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
          ],
        ),
      ),
    );
  }
}
