import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class InvoiceItemCard extends StatelessWidget {
  final String id;
  final String number;
  final String date;
  final String amount;
  final String status;
  final VoidCallback onDownload;

  const InvoiceItemCard({
    super.key,
    required this.id,
    required this.number,
    required this.date,
    required this.amount,
    required this.status,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'paid';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isPaid ? AppColor.success : AppColor.warning).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_outlined,
              color: isPaid ? AppColor.success : AppColor.warning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(date, style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary)),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              if (id.isNotEmpty)
                InkWell(
                  onTap: onDownload,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Download PDF',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
