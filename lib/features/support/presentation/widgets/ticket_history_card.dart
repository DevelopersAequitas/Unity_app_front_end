import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/support_ticket_entity.dart';
import 'ticket_details_sheet.dart';
import 'ticket_status_badge.dart';

class TicketHistoryCard extends StatelessWidget {
  final SupportTicketEntity ticket;

  const TicketHistoryCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => TicketDetailsSheet.show(context, ticket: ticket),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                TicketStatusBadge(status: ticket.status),
              ],
            ),
            if (ticket.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                ticket.description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.lightTextSecondary,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColor.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ticket.department,
                    style: const TextStyle(fontSize: 10, color: AppColor.lightTextSecondary),
                  ),
                ),
                if (ticket.id.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '#${ticket.id}',
                    style: const TextStyle(fontSize: 11, color: AppColor.lightTextTertiary),
                  ),
                ],
                const Spacer(),
                if (ticket.createdAt.isNotEmpty)
                  Text(
                    AppDateFormatter.format(ticket.createdAt),
                    style: const TextStyle(fontSize: 11, color: AppColor.lightTextTertiary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
