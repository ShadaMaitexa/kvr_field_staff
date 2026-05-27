import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/super_admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class GlobalVisitViewScreen extends ConsumerWidget {
  const GlobalVisitViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saState = ref.watch(superAdminViewModelProvider);
    final visits = saState.globalVisits;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Global Visits'),
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
                    onSelected: (_) => ref
                        .read(superAdminViewModelProvider.notifier)
                        .loadGlobalVisits(),
                    selectedColor:
                        AppColors.teal.withValues(alpha: 0.2),
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
            child: saState.isLoading
                ? const ShimmerLoading()
                : visits.isEmpty
                    ? const EmptyState(
                        icon: Icons.public_off,
                        title: 'No visits found',
                        subtitle: 'Visit data will appear here.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: visits.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final visit = visits[index];
                          final timeStr = DateFormat('hh:mm a • dd MMM yyyy')
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
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.navy
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(
                                              AppSpacing.radiusSm),
                                    ),
                                    child: const Icon(Icons.place,
                                        color: AppColors.teal),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          visit.locationName,
                                          style: AppTextStyles
                                              .bodyMedium
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color:
                                                      AppColors.navy),
                                        ),
                                        Text(
                                          'Staff: ${visit.staffId.substring(0, 8)}...',
                                          style:
                                              AppTextStyles.bodySmall,
                                        ),
                                        Text(
                                          timeStr,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                  color: Colors.grey),
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
