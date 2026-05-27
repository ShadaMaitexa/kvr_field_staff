import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class VisitLogScreen extends ConsumerWidget {
  const VisitLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminViewModelProvider);
    final visits = adminState.recentVisits;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Visit Logs'),
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
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.navy.withValues(alpha: 0.5)),
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.navy),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
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
                          avatar:
                              const Icon(Icons.calendar_today, size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Visit List
            Expanded(
              child: adminState.isLoading
                  ? const ShimmerLoading()
                  : visits.isEmpty
                      ? const EmptyState(
                          icon: Icons.list_alt_outlined,
                          title: 'No visits logged',
                          subtitle: 'Visit logs will appear here.',
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
                            // Find staff name
                            final staff = adminState.staffList
                                .where((s) => s.id == visit.staffId);
                            final staffName = staff.isNotEmpty
                                ? staff.first.name
                                : 'Unknown Staff';

                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd),
                                onTap: () => context.push(
                                    '/admin/visit-detail',
                                    extra: visit),
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  staffName,
                                                  style: AppTextStyles
                                                      .bodyLarge
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                ),
                                                Text(timeStr,
                                                    style: AppTextStyles
                                                        .bodySmall),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.location_on,
                                                    size: 14,
                                                    color: AppColors.teal),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    visit.locationName,
                                                    style: AppTextStyles
                                                        .bodySmall,
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
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
