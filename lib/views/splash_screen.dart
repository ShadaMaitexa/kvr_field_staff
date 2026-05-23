import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: const Icon(
                  Icons.directions_car_filled_outlined,
                  size: 56,
                  color: AppColors.teal,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'KVR MOTORS',
                style: AppTextStyles.titleLarge.copyWith(
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Detecting your role...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
