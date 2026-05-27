import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/super_admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class AddCompanyScreen extends ConsumerStatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  ConsumerState<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends ConsumerState<AddCompanyScreen> {
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Add Company'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
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
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: _isSaving ? 'Adding...' : 'Add Company',
              onPressed:
                  (_nameController.text.trim().isNotEmpty && !_isSaving)
                      ? () async {
                          setState(() => _isSaving = true);
                          await ref
                              .read(superAdminViewModelProvider.notifier)
                              .addCompany(_nameController.text.trim());
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Company added successfully!')),
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
