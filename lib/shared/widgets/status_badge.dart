import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

enum BadgeSize { small, medium }

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final BadgeSize size;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.size = BadgeSize.medium,
    this.icon,
  });

  factory StatusBadge.fromStatus(String status,
      {BadgeSize size = BadgeSize.medium}) {
    final config = _statusConfig(status);
    return StatusBadge(
      label: config.$1,
      backgroundColor: config.$2,
      textColor: config.$3,
      size: size,
      icon: config.$4,
    );
  }

  static (String, Color, Color, IconData?) _statusConfig(String status) {
    switch (status.toLowerCase()) {
      // Orders
      case 'pending':
        return (
          'Pending',
          AppColors.goldLight,
          AppColors.warmGold,
          Icons.schedule_rounded
        );
      case 'confirmed':
        return (
          'Confirmed',
          AppColors.oliveLight,
          AppColors.oliveGreen,
          Icons.check_circle_outline_rounded
        );
      case 'preparing':
        return (
          'Preparing',
          const Color(0xFFE8F4FD),
          const Color(0xFF2196F3),
          Icons.soup_kitchen_outlined
        );
      case 'ready':
        return (
          'Ready',
          AppColors.sageLight,
          AppColors.sageGreen,
          Icons.done_all_rounded
        );
      case 'out_for_delivery':
        return (
          'On the Way',
          const Color(0xFFE8F4FD),
          const Color(0xFF1976D2),
          Icons.local_shipping_outlined
        );
      case 'delivered':
        return (
          'Delivered',
          AppColors.oliveLight,
          AppColors.successGreen,
          Icons.check_circle_rounded
        );
      case 'cancelled':
        return (
          'Cancelled',
          const Color(0xFFFBE9E7),
          AppColors.errorRed,
          Icons.cancel_outlined
        );

      // Company
      case 'approved':
        return (
          'Approved',
          AppColors.oliveLight,
          AppColors.successGreen,
          Icons.verified_rounded
        );
      case 'rejected':
        return (
          'Rejected',
          const Color(0xFFFBE9E7),
          AppColors.errorRed,
          Icons.block_rounded
        );
      case 'suspended':
        return (
          'Suspended',
          const Color(0xFFF3E5F5),
          const Color(0xFF7B1FA2),
          Icons.pause_circle_outline_rounded
        );

      // Group Orders
      case 'draft':
        return (
          'Draft',
          AppColors.softBeige,
          AppColors.mutedText,
          Icons.edit_outlined
        );
      case 'open':
        return (
          'Open',
          AppColors.sageLight,
          AppColors.oliveGreen,
          Icons.lock_open_rounded
        );
      case 'closed':
        return (
          'Closed',
          AppColors.softBeige,
          AppColors.mutedText,
          Icons.lock_rounded
        );
      case 'waiting_payment':
        return (
          'Awaiting Payment',
          AppColors.goldLight,
          AppColors.warmGold,
          Icons.payment_outlined
        );

      // Meal Prep
      case 'active':
        return (
          'Active',
          AppColors.oliveLight,
          AppColors.successGreen,
          Icons.play_circle_outline_rounded
        );
      case 'paused':
        return (
          'Paused',
          AppColors.goldLight,
          AppColors.warmGold,
          Icons.pause_circle_outline_rounded
        );
      case 'completed':
        return (
          'Completed',
          AppColors.softBeige,
          AppColors.mutedText,
          Icons.flag_rounded
        );

      // Catering
      case 'quoted':
        return (
          'Quoted',
          const Color(0xFFE3F2FD),
          const Color(0xFF1565C0),
          Icons.request_quote_outlined
        );
      case 'accepted':
        return (
          'Accepted',
          AppColors.sageLight,
          AppColors.oliveGreen,
          Icons.thumb_up_outlined
        );
      case 'in_preparation':
        return (
          'In Preparation',
          const Color(0xFFE8F4FD),
          const Color(0xFF2196F3),
          Icons.soup_kitchen_outlined
        );

      // Invoice
      case 'paid':
        return (
          'Paid',
          AppColors.oliveLight,
          AppColors.successGreen,
          Icons.check_circle_rounded
        );
      case 'overdue':
        return (
          'Overdue',
          const Color(0xFFFBE9E7),
          AppColors.errorRed,
          Icons.warning_amber_rounded
        );

      // Members
      case 'invited':
        return (
          'Invited',
          AppColors.goldLight,
          AppColors.warmGold,
          Icons.mail_outline_rounded
        );

      default:
        return (status, AppColors.softBeige, AppColors.mutedText, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = size == BadgeSize.small;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: textColor.withAlpha(34)),
        boxShadow: [
          BoxShadow(
            color: textColor.withAlpha(16),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 11 : 13, color: textColor),
            SizedBox(width: isSmall ? 3 : 4),
          ],
          Text(
            label,
            style: (isSmall ? AppTypography.labelSm : AppTypography.labelMd)
                .copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
