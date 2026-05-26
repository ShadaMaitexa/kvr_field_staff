import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class AddCompanyScreen extends StatelessWidget {
  const AddCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Add Company',
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: 'Add Company',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}


