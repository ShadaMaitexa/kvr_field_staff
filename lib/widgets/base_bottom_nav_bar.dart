import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class BaseBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;

  const BaseBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.teal,
      unselectedItemColor: AppColors.navy.withValues(alpha: 0.5),
      selectedLabelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyles.bodySmall,
      items: items,
      onTap: (_) {}, // Static for now, no logic
    );
  }
}
