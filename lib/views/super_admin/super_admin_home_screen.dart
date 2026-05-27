import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/super_admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class SuperAdminHomeScreen extends ConsumerWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;
    final saState = ref.watch(superAdminViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Super Admin Home',
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            onPressed: () => context.push('/super-admin/global-visits'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(superAdminViewModelProvider.notifier)
                .loadDashboardData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: saState.isLoading
            ? const ShimmerLoading()
            : RefreshIndicator(
                onRefresh: () => ref
                    .read(superAdminViewModelProvider.notifier)
                    .loadDashboardData(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    Text(
                      'Welcome, ${user?.name ?? "Super Admin"}!',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    if (saState.error != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text(
                          'Error: ${saState.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // 2x2 Stat Grid
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Companies',
                            value:
                                saState.companies.length.toString(),
                            icon: Icons.business,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: StatCard(
                            label: 'Total Admins',
                            value: saState.totalAdmins.toString(),
                            icon: Icons.admin_panel_settings,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Active Staff',
                            value: saState.activeStaff.toString(),
                            icon: Icons.people,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: StatCard(
                            label: 'Visits Today',
                            value: saState.visitsToday.toString(),
                            icon: Icons.location_on,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Companies
                    Text('Companies', style: AppTextStyles.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    if (saState.companies.isEmpty)
                      const EmptyState(
                        icon: Icons.business_outlined,
                        title: 'No companies found',
                        subtitle: 'Tap + to add a company.',
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: saState.companies.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final company = saState.companies[index];
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.blue
                                    .withValues(alpha: 0.1),
                                child: const Icon(Icons.business,
                                    color: AppColors.teal),
                              ),
                              title: Text(
                                company.name,
                                style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '${company.staffCount} Staff Members'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.teal
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Active',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(
                                          color: AppColors.teal),
                                ),
                              ),
                              onTap: () => context.push(
                                  '/super-admin/company-detail',
                                  extra: company),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        onPressed: () => context.push('/super-admin/add-company'),
        icon: const Icon(Icons.add, color: Colors.white),
        label:
            const Text('Add Company', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
