import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class AssignTaskScreen extends ConsumerStatefulWidget {
  const AssignTaskScreen({super.key});

  @override
  ConsumerState<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends ConsumerState<AssignTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedAssigneeId;
  DateTime? _selectedDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminViewModelProvider);
    final staff = adminState.staffList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Assign Task'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
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
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
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
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _selectedAssigneeId,
              decoration: InputDecoration(
                labelText: 'Assign To',
                labelStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              items: staff
                  .map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(s.name),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedAssigneeId = value),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: _selectedDate == null
                    ? 'Due Date'
                    : 'Due: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}',
                labelStyle: AppTextStyles.bodyMedium,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate:
                      DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: _isSaving ? 'Assigning...' : 'Assign Task',
              onPressed: (_titleController.text.trim().isNotEmpty &&
                      _selectedAssigneeId != null &&
                      _selectedDate != null &&
                      !_isSaving)
                  ? () async {
                      setState(() => _isSaving = true);
                      await ref
                          .read(adminViewModelProvider.notifier)
                          .assignTask(
                            title: _titleController.text.trim(),
                            description:
                                _descriptionController.text.trim(),
                            assigneeId: _selectedAssigneeId!,
                            dueDate: _selectedDate!,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Task assigned successfully!')),
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
