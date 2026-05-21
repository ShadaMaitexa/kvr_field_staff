import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SuperAdminHomeScreen extends ConsumerWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.userModel;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.name ?? "Super Admin"}!',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Role: ${user?.role ?? "Unknown"}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),
            const Text('Super Admin features coming soon...'),
          ],
        ),
      ),
    );
  }
}
