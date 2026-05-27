import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/staff_viewmodel.dart';
import '../../widgets/primary_button.dart';

class VisitConfirmedScreen extends ConsumerWidget {
  const VisitConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffState = ref.watch(staffViewModelProvider);
    final visit = staffState.lastSavedVisit;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 64,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                'Visit Confirmed!',
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              Text(
                'Your visit to ${visit?.locationName ?? "the location"} has been successfully recorded.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Distance Card
              Card(
                elevation: 0,
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  side: BorderSide(
                      color: AppColors.navy.withValues(alpha: 0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.directions_car, color: AppColors.teal),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Distance Covered',
                              style: AppTextStyles.bodySmall),
                          Text(
                            '${visit?.distanceInKm?.toStringAsFixed(1) ?? "0.0"} km',
                            style: AppTextStyles.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Action Buttons
              PrimaryButton(
                label: 'Back to Home',
                onPressed: () => context.go('/staff'),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.go('/staff'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.navy),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: Text(
                  'View Visit History',
                  style:
                      AppTextStyles.buttonText.copyWith(color: AppColors.navy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
