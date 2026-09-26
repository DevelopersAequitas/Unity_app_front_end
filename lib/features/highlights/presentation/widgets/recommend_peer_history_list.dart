import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/peer_recommendation_entity.dart';

class RecommendPeerHistoryList extends StatelessWidget {
  final List<PeerRecommendationEntity> history;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  const RecommendPeerHistoryList({
    super.key,
    required this.history,
    required this.isLoading,
    required this.onRefresh,
  });

  static const Map<String, String> _relationshipLabels = {
    'business_associate': 'Business Associate',
    'close_friend': 'Close Friend',
    'client': 'Client / Customer',
    'community_contact': 'Community Contact',
  };

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    return AppDateFormatter.format(raw);
  }

  void _showDetailBottomSheet(BuildContext context, PeerRecommendationEntity item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final textPrimary =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    final dateStr = item.submittedAt ?? item.createdAt;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommendation Details',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: textSecondary,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: borderColor),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    children: [
                      _sectionTitle('OVERVIEW', textSecondary),
                      _detailRow('Submitted', _formatDate(dateStr), textPrimary, textSecondary),
                      if (item.circleName != null && item.circleName!.isNotEmpty)
                        _detailRow('Circle', item.circleName!, textPrimary, textSecondary),

                      const SizedBox(height: 12),
                      _sectionTitle('PEER INFORMATION', textSecondary),
                      _detailRow('Full Name', item.peerName, textPrimary, textSecondary),
                      _detailRow('Mobile Number', item.peerMobile, textPrimary, textSecondary),
                      if (item.peerEmail != null && item.peerEmail!.isNotEmpty)
                        _detailRow('Email ID', item.peerEmail!, textPrimary, textSecondary),
                      if (item.peerCityCountry != null && item.peerCityCountry!.isNotEmpty)
                        _detailRow('City & Country', item.peerCityCountry!, textPrimary, textSecondary),
                      if (item.peerBusiness != null && item.peerBusiness!.isNotEmpty)
                        _detailRow('Business / Profession', item.peerBusiness!, textPrimary, textSecondary),

                      const SizedBox(height: 12),
                      _sectionTitle('CATEGORY & SPECIALIZATION', textSecondary),
                      if (item.mainCategoryName != null && item.mainCategoryName!.isNotEmpty)
                        _detailRow('Main Business Category', item.mainCategoryName!, textPrimary, textSecondary),
                      if (item.subCategoryName != null && item.subCategoryName!.isNotEmpty)
                        _detailRow('Subcategory / Specialization', item.subCategoryName!, textPrimary, textSecondary),
                      if ((item.mainCategoryName == null || item.mainCategoryName!.isEmpty) &&
                          item.peerCategory != null && item.peerCategory!.isNotEmpty)
                        _detailRow('Category', item.peerCategory!, textPrimary, textSecondary),

                      const SizedBox(height: 12),
                      _sectionTitle('YOUR FEEDBACK & CONTEXT', textSecondary),
                      _detailRow(
                        'Relationship',
                        _relationshipLabels[item.howWellKnown] ?? item.howWellKnown,
                        textPrimary,
                        textSecondary,
                      ),
                      if (item.whyValuable != null && item.whyValuable!.isNotEmpty)
                        _detailRow('Why Valuable', item.whyValuable!, textPrimary, textSecondary, isLongText: true),
                      if (item.note != null && item.note!.isNotEmpty)
                        _detailRow('Note for Team', item.note!, textPrimary, textSecondary, isLongText: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          color: AppColor.primaryBlue,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value,
    Color textPrimary,
    Color textSecondary, {
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: isLongText
                ? AppTypography.bodyMedium.copyWith(
                    color: textPrimary,
                    height: 1.4,
                  )
                : AppTypography.bodyMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final textPrimary =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    if (isLoading && history.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColor.primaryBlue,
        ),
      );
    }

    if (history.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColor.primaryBlue,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: isDark ? 0.15 : 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  size: 48,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Recommendations Yet',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Peers you recommend to join the community will appear here with full status and details.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColor.primaryBlue,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        itemCount: history.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = history[index];
          final dateStr = item.submittedAt ?? item.createdAt;
          final categoryBadge = item.mainCategoryName ?? item.peerCategory;

          return Material(
            color: surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: borderColor, width: 0.8),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _showDetailBottomSheet(context, item),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withValues(alpha: isDark ? 0.18 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColor.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.peerName,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (dateStr != null && dateStr.isNotEmpty)
                                Text(
                                  _formatDate(dateStr),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.peerMobile,
                            style: AppTypography.bodySmall.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (item.peerBusiness != null && item.peerBusiness!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.peerBusiness!,
                              style: AppTypography.bodySmall.copyWith(
                                color: textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (categoryBadge != null && categoryBadge.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryBlue.withValues(alpha: 0.09),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    categoryBadge,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColor.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              if (item.peerCityCountry != null && item.peerCityCountry!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: textSecondary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 11,
                                        color: textSecondary,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        item.peerCityCountry!,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: textSecondary.withValues(alpha: 0.6),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
