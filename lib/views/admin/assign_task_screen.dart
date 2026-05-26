import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class AssignTaskScreen extends StatelessWidget {
  const AssignTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(
        title: 'Assign Task',
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Assignee',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'john', child: Text('John Doe')),
                DropdownMenuItem(value: 'jane', child: Text('Jane Smith')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: 'Due Date',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              readOnly: true,
              onTap: () async {
                // Show date picker
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: 'Assign Task',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}



