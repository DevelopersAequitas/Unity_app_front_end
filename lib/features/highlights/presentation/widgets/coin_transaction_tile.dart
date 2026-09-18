import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/coin_wallet_entity.dart';

class CoinTransactionTile extends StatelessWidget {
  final CoinTransactionEntity transaction;

  const CoinTransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEarned = transaction.type == 'earned';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isEarned
                  ? AppColor.success.withValues(alpha: 0.1)
                  : AppColor.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isEarned ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
              size: 20,
              color: isEarned ? AppColor.success : AppColor.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (transaction.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${isEarned ? '+' : '-'}${transaction.amount}',
            style: AppTypography.titleMedium.copyWith(
              color: isEarned ? AppColor.success : AppColor.error,
            ),
          ),
        ],
      ),
    );
  }
}
