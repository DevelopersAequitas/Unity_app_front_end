import 'package:flutter/material.dart';
import '../../domain/entities/ask_item_entity.dart';

class MyAskCard extends StatelessWidget {
  final AskItemEntity ask;
  final VoidCallback onTap;
  final VoidCallback? onTimelineTap;

  const MyAskCard({
    super.key,
    required this.ask,
    required this.onTap,
    this.onTimelineTap,
  });

  static Color _getFlowColor(String code) {
    switch (code.toLowerCase()) {
      case 'referral':
        return const Color(0xFF16325C);
      case 'help':
        return const Color(0xFF4E3777);
      default:
        return const Color(0xFF0E7A68);
    }
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
      case 'published':
        return const Color(0xFF10B981);
      case 'in_progress':
        return const Color(0xFF0284C7);
      case 'fulfilled':
      case 'completed':
        return const Color(0xFF0E7A68);
      case 'closed':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFFD97706);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final flowColor = _getFlowColor(ask.flowCode);
    final statusColor = _getStatusColor(ask.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: flowColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ask.flowName,
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: flowColor),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ask.status.toUpperCase().replaceAll('_', ' '),
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: statusColor),
                          ),
                        ),
                        if (onTimelineTap != null) ...[
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: onTimelineTap,
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(Icons.history, size: 16, color: subColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  ask.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: titleColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(ask.typeName, style: TextStyle(fontSize: 12, color: subColor)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E7A68).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${ask.matchCount} Matches ↗',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: Color(0xFF0E7A68)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
