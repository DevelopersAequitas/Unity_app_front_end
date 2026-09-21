import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class TicketStatusBadge extends StatelessWidget {
  final String status;

  const TicketStatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    final s = status.toLowerCase().trim();
    if (s.contains('resolved') || s.contains('done') || s.contains('success') || s.contains('closed')) {
      return const Color(0xFF10B981);
    }
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review')) {
      return const Color(0xFFF59E0B);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return AppColor.error;
    }
    return AppColor.primaryBlue;
  }

  Color _getStatusBgColor() {
    final s = status.toLowerCase().trim();
    if (s.contains('resolved') || s.contains('done') || s.contains('success') || s.contains('closed')) {
      return const Color(0xFFECFDF5);
    }
    if (s.contains('progress') || s.contains('waiting') || s.contains('processing') || s.contains('review')) {
      return const Color(0xFFFFFBEB);
    }
    if (s.contains('cancelled') || s.contains('rejected') || s.contains('failed')) {
      return const Color(0xFFFEF2F2);
    }
    return const Color(0xFFEFF6FF);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final bg = _getStatusBgColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
