import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'paid':
        bg = AppColors.successLight;
        fg = AppColors.success;
        icon = Icons.check_circle_rounded;
        label = 'Lunas';
        break;
      case 'pending':
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        icon = Icons.hourglass_top_rounded;
        label = 'Menunggu Bayar';
        break;
      case 'cancelled':
        bg = AppColors.errorLight;
        fg = AppColors.error;
        icon = Icons.cancel_rounded;
        label = 'Dibatalkan';
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
        icon = Icons.info_outline;
        label = status;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 2, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
