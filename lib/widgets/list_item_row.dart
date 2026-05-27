import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class ListItemRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? avatarUrl;
  final String? avatarInitials;
  final Widget? trailingBadge;
  final VoidCallback? onTap;

  const ListItemRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.avatarUrl,
    this.avatarInitials,
    this.trailingBadge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.teal.withValues(alpha: 0.2),
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null && avatarInitials != null
            ? Text(
                avatarInitials!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: trailingBadge,
      onTap: onTap,
    );
  }
}
