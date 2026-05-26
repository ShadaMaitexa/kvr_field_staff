import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const BaseAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
      backgroundColor: AppColors.navy,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      actions: actions,
      leading: leading,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
