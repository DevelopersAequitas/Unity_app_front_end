import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';

class ActivityScriptCard extends StatelessWidget {
  final String statement;
  final String periodName;

  const ActivityScriptCard({
    super.key,
    required this.statement,
    required this.periodName,
  });

  void _copyStatement(BuildContext context) {
    Clipboard.setData(ClipboardData(text: statement));
    AppSnackBar.showSuccess(context, 'Statement copied to clipboard!');
  }

  void _shareStatement() {
    SharePlus.instance.share(
      ShareParams(
        text: '🏆 My Collaboration Summary ($periodName):\n\n$statement\n\n#PeersGlobal #Collaboration',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: AppColor.brandGradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'MONTHLY GRATITUDE STATEMENT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 17, color: AppColor.primaryBlue),
                    tooltip: 'Copy',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () => _copyStatement(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 17, color: AppColor.primaryBlue),
                    tooltip: 'Share',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: _shareStatement,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            statement.isNotEmpty
                ? statement
                : 'No gratitude statement generated for this period.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

