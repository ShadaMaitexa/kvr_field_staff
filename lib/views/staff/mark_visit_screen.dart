import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/staff_viewmodel.dart';
import '../../widgets/base_app_bar.dart';
import '../../widgets/primary_button.dart';

class MarkVisitScreen extends ConsumerStatefulWidget {
  const MarkVisitScreen({super.key});

  @override
  ConsumerState<MarkVisitScreen> createState() => _MarkVisitScreenState();
}

class _MarkVisitScreenState extends ConsumerState<MarkVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffViewModelProvider);
    final hasPhoto = staffState.capturedImage != null;
    final hasLocation = staffState.currentPosition != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BaseAppBar(title: 'Mark Visit'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // GPS Status Card
              Card(
                color: hasLocation
                    ? AppColors.green.withValues(alpha: 0.1)
                    : AppColors.amber.withValues(alpha: 0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  side: BorderSide(
                    color: hasLocation
                        ? AppColors.green.withValues(alpha: 0.3)
                        : AppColors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      if (staffState.isLoadingLocation)
                        const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Icon(
                          hasLocation ? Icons.location_on : Icons.location_off,
                          color: hasLocation ? AppColors.green : AppColors.amber,
                          size: 28,
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasLocation ? 'GPS Connected' : 'GPS Status',
                              style: AppTextStyles.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              staffState.locationStatus,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: hasLocation
                                    ? AppColors.green
                                    : AppColors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!hasLocation)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: AppColors.teal),
                          onPressed: () => ref
                              .read(staffViewModelProvider.notifier)
                              .fetchLocation(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Location Name
              Text('Location Name', style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'e.g. Global Motors, Ernakulam',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.navy.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide:
                        BorderSide(color: AppColors.navy.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide:
                        BorderSide(color: AppColors.navy.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide:
                        const BorderSide(color: AppColors.teal, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Photo Capture Area
              Text('Visit Photo', style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () =>
                    ref.read(staffViewModelProvider.notifier).capturePhoto(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: AppColors.navy.withValues(alpha: 0.2),
                    ),
                    image: hasPhoto
                        ? DecorationImage(
                            image: FileImage(staffState.capturedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasPhoto
                      ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            onPressed: () => ref
                                .read(staffViewModelProvider.notifier)
                                .clearPhoto(),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  size: 48,
                                  color:
                                      AppColors.navy.withValues(alpha: 0.5)),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Tap to capture photo',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color:
                                      AppColors.navy.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.navy.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('Camera only',
                                    style: AppTextStyles.bodySmall),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Notes Field
              Text('Visit Notes (Optional)', style: AppTextStyles.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any remarks or observations here...',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.navy.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide:
                        BorderSide(color: AppColors.navy.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide:
                        BorderSide(color: AppColors.navy.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide:
                        const BorderSide(color: AppColors.teal, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Error message
              if (staffState.error != null) ...[
                Text(
                  staffState.error!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Confirm & Save Button
              PrimaryButton(
                label: staffState.isSavingVisit
                    ? 'Saving...'
                    : 'Confirm & Save Visit',
                onPressed: staffState.isSavingVisit
                    ? null
                    : () async {
                        if (!hasLocation) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wait for GPS connection')),
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          final success = await ref
                              .read(staffViewModelProvider.notifier)
                              .saveVisit(
                                _locationController.text.trim(),
                                _notesController.text.trim(),
                              );
                          if (success && context.mounted) {
                            context.go('/staff/visit-confirmed');
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
