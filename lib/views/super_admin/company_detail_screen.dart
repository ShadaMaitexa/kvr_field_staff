import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/company_model.dart';
import '../../models/user_model.dart';
import '../../viewmodels/super_admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/empty_state.dart';

class CompanyDetailScreen extends ConsumerStatefulWidget {
  final CompanyModel? company;
  const CompanyDetailScreen({super.key, this.company});

  @override
  ConsumerState<CompanyDetailScreen> createState() =>
      _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends ConsumerState<CompanyDetailScreen> {
  List<UserModel> _admins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  Future<void> _loadAdmins() async {
    if (widget.company == null) return;
    final admins = await ref
        .read(superAdminViewModelProvider.notifier)
        .getAdminsForCompany(widget.company!.id);
    if (mounted) {
      setState(() {
        _admins = admins;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.company;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Company Details'),
      body: company == null
          ? const Center(child: Text('Company not found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(company.name,
                              style: AppTextStyles.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Total Staff: ${company.staffCount}',
                              style: AppTextStyles.bodyMedium),
                          Text(
                              'Total Visits: ${company.totalVisits}',
                              style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Company Admins',
                      style: AppTextStyles.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_admins.isEmpty)
                    const EmptyState(
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'No admins found',
                      subtitle: 'Tap + to add an admin.',
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _admins.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final admin = _admins[index];
                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.navy
                                  .withValues(alpha: 0.1),
                              child: Text(
                                admin.name.isNotEmpty
                                    ? admin.name
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    color: AppColors.navy),
                              ),
                            ),
                            title: Text(
                              admin.name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(admin.email),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () async {
                                final confirm =
                                    await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title:
                                        const Text('Remove Admin?'),
                                    content: Text(
                                        'Remove ${admin.name} as admin?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                ctx, false),
                                        child:
                                            const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                ctx, true),
                                        child: const Text(
                                            'Remove',
                                            style: TextStyle(
                                                color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await ref
                                      .read(
                                          superAdminViewModelProvider
                                              .notifier)
                                      .deleteAdmin(admin.id);
                                  _loadAdmins();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal,
        onPressed: () =>
            context.push('/super-admin/add-admin', extra: company),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
