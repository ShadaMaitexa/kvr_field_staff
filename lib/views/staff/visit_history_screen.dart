import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/staff_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class VisitHistoryScreen extends ConsumerWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffState = ref.watch(staffViewModelProvider);
    final visits = staffState.visits;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Visit History'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: staffState.isLoadingData
                  ? const ShimmerLoading()
                  : visits.isEmpty
                      ? const EmptyState(
                          icon: Icons.place_outlined,
                          title: 'No visits yet',
                          subtitle: 'Your visit history will appear here.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: visits.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final visit = visits[index];
                            final timeStr = DateFormat('hh:mm a')
                                .format(visit.createdAt);
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(AppSpacing.sm),
                                child: Row(
                                  children: [
                                    // Photo Thumbnail
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.navy
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(
                                                AppSpacing.radiusSm),
                                        image: visit.photoUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    visit.photoUrl!),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: visit.photoUrl == null
                                          ? Icon(Icons.image_outlined,
                                              color: AppColors.navy
                                                  .withValues(
                                                      alpha: 0.4))
                                          : null,
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            visit.locationName,
                                            style: AppTextStyles.bodyLarge
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                  color: AppColors.teal),
                                              const SizedBox(width: 4),
                                              Text(timeStr,
                                                  style: AppTextStyles
                                                      .bodySmall),
                                              const SizedBox(
                                                  width: AppSpacing.md),
                                              const Icon(
                                                  Icons.location_on,
                                                  size: 14,
                                                  color: AppColors.teal),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${visit.latitude.toStringAsFixed(4)}, ${visit.longitude.toStringAsFixed(4)}',
                                                style: AppTextStyles
                                                    .bodySmall,
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
                    Text('Total Distance Today',
                        style: AppTextStyles.titleMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusRound),
                      ),
                      child: Text(
                        '${staffState.totalDistanceKm.toStringAsFixed(1)} km',
                        style: AppTextStyles.titleMedium
                            .copyWith(color: AppColors.teal),
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
