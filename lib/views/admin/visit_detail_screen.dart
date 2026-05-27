import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/visit_model.dart';
import '../../widgets/base_app_bar.dart';

class VisitDetailScreen extends StatelessWidget {
  final VisitModel? visit;
  const VisitDetailScreen({super.key, this.visit});

  @override
  Widget build(BuildContext context) {
    final v = visit;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Visit Details'),
      body: v == null
          ? const Center(child: Text('Visit not found.'))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Full Photo
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.navy.withValues(alpha: 0.1),
                      image: v.photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(v.photoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: v.photoUrl == null
                        ? const Icon(Icons.image_outlined,
                            size: 64, color: Colors.grey)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.locationName,
                            style: AppTextStyles.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          DateFormat('hh:mm a • dd MMM yyyy')
                              .format(v.createdAt),
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Location details
                        Text('Location',
                            style: AppTextStyles.titleSmall),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: AppColors.teal),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'GPS: ${v.latitude.toStringAsFixed(4)}° N, ${v.longitude.toStringAsFixed(4)}° E',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        if (v.distanceInKm != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text('Distance',
                              style: AppTextStyles.titleSmall),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Icon(Icons.directions_car,
                                  color: AppColors.teal),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${v.distanceInKm!.toStringAsFixed(1)} km from previous visit',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                        if (v.notes != null &&
                            v.notes!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text('Notes',
                              style: AppTextStyles.titleSmall),
                          const SizedBox(height: AppSpacing.xs),
                          Text(v.notes!,
                              style: AppTextStyles.bodyMedium),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
