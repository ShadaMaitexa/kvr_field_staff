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
  final _formKey = GlobalKey<FormState>();
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
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
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an assignee';
                }
                return null;
              },
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
            TextFormField(
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
              validator: (value) {
                if (_selectedDate == null) {
                  return 'Please select a due date';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: _isSaving ? 'Assigning...' : 'Assign Task',
              onPressed: _isSaving
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
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
                    },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
