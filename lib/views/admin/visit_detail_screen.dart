import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/base_app_bar.dart';

class VisitDetailScreen extends StatelessWidget {
  const VisitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Visit Details',
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Photo
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.navy.withValues(alpha: 0.1),
              child: const Icon(
                Icons.image_outlined,
                size: 64,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '10:30 AM • 26 May 2026',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Location details
                  const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.teal),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Global Motors, Ernakulam\nGPS: 9.9312° N, 76.2673° E',
                          style: AppTextStyles.bodyMedium,
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
  }
}

