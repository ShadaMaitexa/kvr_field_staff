import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/company_model.dart';
import '../../viewmodels/super_admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class AddAdminScreen extends ConsumerStatefulWidget {
  final CompanyModel? company;
  const AddAdminScreen({super.key, this.company});

  @override
  ConsumerState<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends ConsumerState<AddAdminScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedCompanyId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCompanyId = widget.company?.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saState = ref.watch(superAdminViewModelProvider);
    final companies = saState.companies;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Add Admin'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide:
                      const BorderSide(color: AppColors.teal, width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  borderSide:
                      const BorderSide(color: AppColors.teal, width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _selectedCompanyId,
              decoration: InputDecoration(
                labelText: 'Assign to Company',
                labelStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              items: companies
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedCompanyId = value),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: _isSaving ? 'Adding...' : 'Add Admin',
              onPressed: (_nameController.text.trim().isNotEmpty &&
                      _emailController.text.trim().isNotEmpty &&
                      _selectedCompanyId != null &&
                      !_isSaving)
                  ? () async {
                      setState(() => _isSaving = true);
                      await ref
                          .read(superAdminViewModelProvider.notifier)
                          .addAdmin(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            companyId: _selectedCompanyId!,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Admin added successfully!')),
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
