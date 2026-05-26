import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class AddAdminScreen extends StatelessWidget {
  const AddAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Add Admin',
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Assign to Company',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              items: const [
                DropdownMenuItem(value: '1', child: Text('Global Motors')),
                DropdownMenuItem(value: '2', child: Text('TechCorp')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: 'Add Admin',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}


