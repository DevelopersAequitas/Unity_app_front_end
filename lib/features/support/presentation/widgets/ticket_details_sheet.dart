import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/support_ticket_entity.dart';
import 'ticket_status_badge.dart';

class TicketDetailsSheet extends StatelessWidget {
  final SupportTicketEntity ticket;

  const TicketDetailsSheet({super.key, required this.ticket});

  static void show(BuildContext context, {required SupportTicketEntity ticket}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TicketDetailsSheet(ticket: ticket),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.lightTextPrimary,
                    ),
                  ),
                ),
                TicketStatusBadge(status: ticket.status),
              ],
            ),
            if (ticket.id.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Ticket #${ticket.id}',
                style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextTertiary),
              ),
            ],
            const Divider(height: 24),
            Row(
              children: [
                _chip(Icons.folder_outlined, ticket.department),
                const SizedBox(width: 8),
                _chip(Icons.flag_outlined, '${ticket.priority} Priority'),
                if (ticket.createdAt.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _chip(Icons.access_time_rounded, AppDateFormatter.format(ticket.createdAt)),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ticket.description.isNotEmpty ? ticket.description : 'No description provided.',
              style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextPrimary, height: 1.4),
            ),
            if (ticket.adminReply != null && ticket.adminReply!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.support_agent_rounded, size: 16, color: Color(0xFF16A34A)),
                        const SizedBox(width: 6),
                        Text(
                          'Support Response',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ticket.adminReply!,
                      style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextPrimary, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.lightTextSecondary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: AppColor.lightTextSecondary)),
        ],
      ),
    );
  }
}
