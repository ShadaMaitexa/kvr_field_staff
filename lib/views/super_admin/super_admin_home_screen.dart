import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/super_admin_viewmodel.dart';
import '../../widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class SuperAdminHomeScreen extends ConsumerWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;
    final superAdminState = ref.watch(superAdminViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Home'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Welcome, ${user?.name ?? "Super Admin"}!',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          // 2x2 Stat Grid
          if (superAdminState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (superAdminState.error != null)
            Center(child: Text('Error: ${superAdminState.error}', style: const TextStyle(color: Colors.red)))
          else
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard('Total Companies', superAdminState.companies.length.toString(), Icons.business),
                _buildStatCard('Total Admins', superAdminState.totalAdmins.toString(), Icons.admin_panel_settings),
                _buildStatCard('Active Staff', superAdminState.activeStaff.toString(), Icons.people),
                _buildStatCard('Visits Today', superAdminState.visitsToday.toString(), Icons.location_on),
              ],
            ),
          const SizedBox(height: 24),
          Text(
            'Companies',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 12),
          // Company List
          if (superAdminState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (superAdminState.companies.isEmpty)
            const Center(child: Text('No companies found.'))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: superAdminState.companies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final company = superAdminState.companies[index];
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.lightBlue,
                      child: Icon(Icons.business, color: AppColors.teal),
                    ),
                    title: Text(
                      company.name,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${company.staffCount} Staff Members'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal),
                      ),
                    ),
                    onTap: () {
                      context.push('/super_admin/company_detail', extra: company);
                    },
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.teal,
        onPressed: () {
          context.push('/super_admin/add_company');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Company', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.navy.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
