import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/ask_item_entity.dart';
import 'ask_card_highlight_wrapper.dart';

class PeersFeedCard extends StatelessWidget {
  final AskItemEntity item;
  final VoidCallback onHelpTap;
  final VoidCallback onCongratulate;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final bool isCongratulated;
  final bool isSaved;
  final bool isHighlighted;

  const PeersFeedCard({
    super.key,
    required this.item,
    required this.onHelpTap,
    required this.onCongratulate,
    required this.onShare,
    required this.onSave,
    this.isCongratulated = false,
    this.isSaved = false,
    this.isHighlighted = false,
  });

  void _onViewPeerProfile(BuildContext context, String? peerId) {
    if (peerId == null || peerId.isEmpty) return;
    Navigator.of(context).pushNamed(
      AppRoutes.peerProfile,
      arguments: peerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    final isStory = item.itemType == 'story' ||
        item.itemType == 'ask_fulfilled' ||
        item.itemType == 'spotlight' ||
        item.storyText != null;
    final isSpotlight = item.itemType == 'spotlight' ||
        item.title.toLowerCase().contains('spotlight');

    return AskCardHighlightWrapper(
      isHighlighted: isHighlighted,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.9),
        ),
        child: isStory
            ? _buildStoryLayout(isDark, titleColor, isSpotlight)
            : _buildAskLayout(context, isDark, titleColor),
      ),
    );
  }

  Widget _buildStoryLayout(bool isDark, Color titleColor, bool isSpotlight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChip(
          label: isSpotlight ? 'Giver Spotlight' : 'Ask Fulfilled',
          bgColor: isDark ? AppColor.darkSurfaceSubtle : AppColor.badgeBlueBg,
          textColor: isDark ? AppColor.darkTextPrimary : AppColor.primaryBlue,
        ),
        const SizedBox(height: 8),
        Text(
          item.storyText ?? item.title,
          style: AppTypography.titleMedium.copyWith(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: titleColor,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionPill(
              label: isCongratulated || item.isCongratulated
                  ? 'Congratulated 🎉'
                  : 'Congratulate',
              isSelected: isCongratulated || item.isCongratulated,
              isDark: isDark,
              onTap: onCongratulate,
            ),
            const SizedBox(width: 8),
            _buildActionPill(
              label: 'Share',
              isSelected: false,
              isDark: isDark,
              onTap: onShare,
            ),
            const SizedBox(width: 8),
            _buildActionPill(
              label: isSaved || item.isSaved ? 'Saved' : 'Save',
              isSelected: isSaved || item.isSaved,
              isDark: isDark,
              onTap: onSave,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAskLayout(BuildContext context, bool isDark, Color titleColor) {
    final subColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    final profile = context.watch<ProfileBloc?>()?.state.profile;
    final currentUserId = profile?.id ?? '';
    final authorId = item.authorId;
    final authorName = item.authorName.isNotEmpty
        ? item.authorName
        : (item.rawData['author_name'] ?? '').toString();
    final authorCompany = item.authorCompany;
    final authorCity = item.authorCity;
    final authorAvatar = item.authorAvatar;

    final isMyAsk = (currentUserId.isNotEmpty && authorId.isNotEmpty && currentUserId == authorId) ||
        (profile != null && profile.displayName.isNotEmpty && authorName == profile.displayName);

    final toUserName = item.toUserName;
    final toUserCompany = item.toUserCompany;
    final category = item.category;
    final timeAgo = item.timeAgo;
    final hotValue = item.hotValue;
    final description = item.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Peer Author Header
        if (authorName.isNotEmpty || authorAvatar != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _onViewPeerProfile(context, authorId),
                child: AppAvatar(
                  imageUrl: authorAvatar,
                  name: authorName.isNotEmpty ? authorName : 'Peer',
                  size: 38,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onViewPeerProfile(context, authorId),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName.isNotEmpty ? authorName : 'Peer',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (authorCompany.isNotEmpty || authorCity.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          [authorCompany, authorCity]
                              .where((e) => e.isNotEmpty)
                              .join(' • '),
                          style: TextStyle(
                            fontSize: 12,
                            color: subColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (timeAgo.isNotEmpty)
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: subColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // 2. Referral "Given To" Banner (if applicable)
        if (toUserName.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_right_alt_rounded,
                  size: 16,
                  color: AppColor.primaryBlue,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Referral for ',
                      style: TextStyle(
                        fontSize: 12,
                        color: subColor,
                      ),
                      children: [
                        TextSpan(
                          text: toUserName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                        if (toUserCompany.isNotEmpty)
                          TextSpan(
                            text: ' ($toUserCompany)',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: subColor,
                            ),
                          ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 3. Category & Attribute Badges
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            if (category.isNotEmpty && category.toLowerCase() != 'general')
              _buildChip(
                label: category,
                bgColor: isDark
                    ? AppColor.darkSurfaceSubtle
                    : const Color(0xFFDBEAFE),
                textColor: isDark
                    ? AppColor.primaryBlue
                    : const Color(0xFF1E3A8A),
              ),
            if (hotValue > 0)
              _buildChip(
                label: '🔥 Hot: $hotValue',
                bgColor: isDark
                    ? const Color(0xFF33200A)
                    : const Color(0xFFFEF3C7),
                textColor: const Color(0xFFD97706),
              ),
            if (item.statusLabel.isNotEmpty && item.statusLabel.toLowerCase() != 'open')
              _buildChip(
                label: item.statusLabel,
                bgColor: isDark
                    ? const Color(0xFF0D3328)
                    : const Color(0xFFE6F4F1),
                textColor: const Color(0xFF0E7A68),
              ),
            if (isMyAsk)
              _buildChip(
                label: 'Your Ask',
                bgColor: isDark
                    ? const Color(0xFF0D3328)
                    : const Color(0xFFE6F4F1),
                textColor: const Color(0xFF0E7A68),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // 4. Ask Title
        Text(
          item.title,
          style: AppTypography.titleMedium.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: titleColor,
            height: 1.3,
          ),
        ),

        // 5. Description / Offering / Remarks
        if (description.isNotEmpty && description != item.title) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: bodyColor,
              height: 1.35,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (item.offeringInReturn.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Offering in return: ${item.offeringInReturn.replaceAll('_', ' ')}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],

        // 6. Action Footer Row
        const SizedBox(height: 12),
        if (isMyAsk) ...[
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton.icon(
              onPressed: onHelpTap,
              icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
              label: Text(
                'View My Ask & Responses (${item.responseCount})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.primaryBlue,
                side: BorderSide(
                  color: AppColor.primaryBlue.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColor.brandGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: onHelpTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'I Can Help',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onSave,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                  ),
                  child: Icon(
                    isSaved || item.isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 18,
                    color: isSaved || item.isSaved
                        ? AppColor.primaryBlue
                        : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: onShare,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    size: 17,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
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

  Widget _buildActionPill({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryBlue.withValues(alpha: 0.14)
              : (isDark
                  ? AppColor.darkSurfaceSubtle
                  : AppColor.lightSurfaceSubtle),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColor.primaryBlue, width: 1)
              : Border.all(
                  color:
                      isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  width: 0.8,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColor.primaryBlue
                : (isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}

