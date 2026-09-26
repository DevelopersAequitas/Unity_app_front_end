import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import 'referral_status_bottom_sheet.dart';

class MyAskDashboardCard extends StatelessWidget {
  final AskItemEntity ask;
  final VoidCallback onReviewTap;
  final VoidCallback? onCardTap;

  const MyAskDashboardCard({
    super.key,
    required this.ask,
    required this.onReviewTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final subColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final isReferral = ask.flowCode == 'referral' ||
        ask.flowName.toLowerCase().contains('referral');
    final responseCount = ask.responseCount;
    final hasResponses = responseCount > 0;
    final hasFlow = ask.flowName.isNotEmpty &&
        ask.flowName.toLowerCase() != 'ask' &&
        ask.flowName.toLowerCase() != ask.typeName.toLowerCase();
    final hasType =
        ask.typeName.isNotEmpty && ask.typeName.toLowerCase() != 'general';
    final subtitle = ask.subtitle ??
        (hasResponses
            ? 'Tap to review $responseCount responder${responseCount > 1 ? 's' : ''}'
            : (ask.isFulfilled
                ? 'Fulfilled & closed'
                : 'Boosted to matching Givers in your network'));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCardTap ?? onReviewTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges Row
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (hasFlow)
                            _buildChip(
                              label: ask.flowName,
                              bgColor: isDark
                                  ? AppColor.darkSurfaceSubtle
                                  : const Color(0xFFDBEAFE),
                              textColor: isDark
                                  ? AppColor.primaryBlue
                                  : const Color(0xFF1E3A8A),
                            ),
                          if (hasType || !hasFlow)
                            _buildChip(
                              label: hasType ? ask.typeName : ask.flowName,
                              bgColor: isDark
                                  ? AppColor.darkSurfaceSubtle
                                  : AppColor.badgeBlueBg,
                              textColor: isDark
                                  ? AppColor.darkTextPrimary
                                  : AppColor.primaryBlue,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isReferral)
                      GestureDetector(
                        onTap: ask.isReferralFinalStatus
                            ? null
                            : () {
                                ReferralStatusBottomSheet.showForAskItem(
                                  context,
                                  item: ask,
                                  onSelectStatus: (selected) {
                                    context.read<MyAsksBloc>().add(
                                          UpdateAskStatusRequested(
                                            askId: ask.id,
                                            status: selected.name
                                                .toLowerCase()
                                                .replaceAll(' ', '_'),
                                            statusId: selected.id,
                                          ),
                                        );
                                  },
                                );
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: _getReferralStatusBgColor(ask.statusLabel, isDark),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _getReferralStatusTextColor(ask.statusLabel)
                                  .withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: _getReferralStatusTextColor(ask.statusLabel),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                ask.statusLabel.isNotEmpty
                                    ? ask.statusLabel
                                    : 'Open',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getReferralStatusTextColor(ask.statusLabel),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                ask.isReferralFinalStatus
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.arrow_drop_down,
                                size: 14,
                                color: _getReferralStatusTextColor(ask.statusLabel),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      _buildChip(
                        label: hasResponses
                            ? '$responseCount response${responseCount > 1 ? 's' : ''}'
                            : (ask.isFulfilled
                                ? 'Fulfilled'
                                : (ask.isExpired ? 'Expired' : 'Open')),
                        bgColor: hasResponses
                            ? (isDark
                                ? const Color(0xFF132A4A)
                                : const Color(0xFFE0F2FE))
                            : (ask.isFulfilled
                                ? (isDark
                                    ? const Color(0xFF0D3328)
                                    : const Color(0xFFE6F4F1))
                                : (isDark
                                    ? const Color(0xFF332A15)
                                    : const Color(0xFFFEF3C7))),
                        textColor: hasResponses
                            ? const Color(0xFF0284C7)
                            : (ask.isFulfilled
                                ? const Color(0xFF059669)
                                : const Color(0xFFD97706)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Ask Title
                Text(
                  ask.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),

                // Subtitle / Detail info with navigation chevron
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: subColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
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

  Widget _buildChip({
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Color _getReferralStatusTextColor(String label) {
    final lower = label.toLowerCase().trim();
    if (lower.contains('got the business') || lower.contains('fulfilled')) {
      return const Color(0xFF16A34A);
    } else if (lower.contains('got things done') || lower.contains('done')) {
      return const Color(0xFF0D9488);
    } else if (lower.contains('contacted') && !lower.contains('not')) {
      return const Color(0xFFD97706);
    } else if (lower.contains('no response')) {
      return const Color(0xFF2563EB);
    } else if (lower.contains('did not get')) {
      return const Color(0xFFDC2626);
    } else if (lower.contains('not a good fit') || lower.contains('unqualified')) {
      return const Color(0xFFEA580C);
    } else if (lower.contains('confidential')) {
      return const Color(0xFF64748B);
    }
    return const Color(0xFF757575);
  }

  Color _getReferralStatusBgColor(String label, bool isDark) {
    final color = _getReferralStatusTextColor(label);
    return isDark ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.1);
  }
}
