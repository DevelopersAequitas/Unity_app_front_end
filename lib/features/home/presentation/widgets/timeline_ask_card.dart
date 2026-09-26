import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../asks/domain/entities/ask_flow_entity.dart';
import '../../../asks/domain/entities/ask_match_peer_entity.dart';
import '../../../asks/domain/entities/ask_submission_entity.dart';
import '../../../asks/domain/entities/ask_type_entity.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'post_options_bottom_sheet.dart';
import 'timeline_author_row.dart';
import 'timeline_interaction_bar.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../asks/presentation/bloc/peers_feed/peers_feed_bloc.dart';
import '../../../asks/presentation/bloc/peers_feed/peers_feed_event.dart';

class TimelineAskCard extends StatefulWidget {
  final TimelineItemEntity item;
  final VoidCallback? onLikeTap;
  final VoidCallback? onLikesCountTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onAuthorTap;

  const TimelineAskCard({
    super.key,
    required this.item,
    this.onLikeTap,
    this.onLikesCountTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
    this.onAuthorTap,
  });

  @override
  State<TimelineAskCard> createState() => _TimelineAskCardState();
}

class _TimelineAskCardState extends State<TimelineAskCard> {
  bool _isCongratulated = false;

  void _handleCongratulate() {
    if (_isCongratulated) return;
    setState(() => _isCongratulated = true);

    final ask = widget.item.askData ?? {};
    final askId = (ask['id'] ?? widget.item.id).toString();

    try {
      context.read<PeersFeedBloc>().add(
            PeersFeedCongratulateRequested(
              askId: askId,
              comment: 'Congratulations! 🎉',
            ),
          );
    } catch (_) {}

    AppSnackBar.showSuccess(
      context,
      'Congratulated! Added your reaction 🎉',
    );
  }

  void _onICanHelp(BuildContext context) {
    final ask = widget.item.askData ?? {};
    final askId = (ask['id'] ?? widget.item.id).toString();
    final flowMap = ask['flow'] is Map ? ask['flow'] as Map : {};
    final typeMap = ask['type'] is Map ? ask['type'] as Map : {};

    final flowCode = (flowMap['code'] ?? 'collaboration').toString();
    final flowName = (flowMap['name'] ??
            (flowCode == 'help'
                ? 'Get Help'
                : (flowCode == 'referral'
                    ? 'Ask for an Introduction'
                    : 'Find a Collaborator')))
        .toString();

    final flow = AskFlowEntity(
      id: (flowMap['id'] ?? flowCode).toString(),
      code: flowCode,
      name: flowName,
      description: '',
    );

    final typeCode = (typeMap['code'] ?? '').toString();
    final typeName = (typeMap['name'] ??
            typeMap['label'] ??
            (typeCode.isNotEmpty
                ? typeCode
                    .replaceAll('_', ' ')
                    .split(' ')
                    .map((w) => w.isNotEmpty
                        ? '${w[0].toUpperCase()}${w.substring(1)}'
                        : '')
                    .join(' ')
                : flow.name))
        .toString();

    final type = AskTypeEntity(
      id: (typeMap['id'] ?? typeCode).toString(),
      flowId: flow.id,
      code: typeCode,
      name: typeName,
    );

    final creator = ask['creator'] is Map ? ask['creator'] as Map : {};
    final creatorId =
        (creator['id'] ?? widget.item.author?.id ?? '').toString();
    final creatorName = (creator['name'] ??
            creator['display_name'] ??
            widget.item.author?.displayName ??
            'Peer')
        .toString();
    final creatorCompany = (creator['company_name'] ??
            creator['designation'] ??
            widget.item.author?.companyName ??
            widget.item.author?.designation ??
            '')
        .toString();
    final creatorPhoto = (creator['profile_photo_url'] ??
            creator['profile_photo_image'] ??
            widget.item.author?.profilePhotoUrl)
        ?.toString();
    final creatorCity =
        (creator['city'] ?? creator['location'] ?? '').toString();

    final peer = AskMatchPeerEntity(
      id: creatorId,
      name: creatorName,
      businessType: creatorCompany,
      location: creatorCity,
      typeLabel: type.name,
      isTypeMatched: true,
      capitalLabel: '',
      isCapitalMatched: true,
      stageLabel: '',
      isStageMatched: true,
      peer: PeerEntity(
        id: creatorId,
        displayName: creatorName,
        companyName: creatorCompany,
        profilePhotoUrl: creatorPhoto,
      ),
    );

    final submission = AskSubmissionEntity(
      flow: flow,
      type: type,
      goal: (ask['title'] ?? widget.item.contentText).toString(),
    );

    Navigator.of(context).pushNamed(
      AppRoutes.askExpressInterest,
      arguments: {
        'peer': peer,
        'submission': submission,
        'askId': askId,
      },
    );
  }

  String _formatTiming(String? raw) {
    if (raw == null || raw.isEmpty) return 'This week';
    switch (raw.toLowerCase().replaceAll(' ', '_')) {
      case 'today':
        return 'Today';
      case 'this_week':
        return 'This week';
      case 'this_month':
        return 'This month';
      case 'three_months':
        return '3 months';
      case 'no_rush':
        return 'No rush';
      default:
        return raw.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final ask = widget.item.askData ?? {};
    final status = (ask['status'] ?? '').toString().toLowerCase();
    final isFulfilled = status == 'fulfilled' || status == 'completed' || widget.item.tags.contains('fulfilled');

    ProfileEntity? profile;
    try {
      profile = context.read<ProfileBloc>().state.profile;
    } catch (_) {}
    final currentUserId = profile?.userId ?? profile?.id ?? '';
    final authorId = widget.item.author?.id ?? '';
    final isMyPost = (currentUserId.isNotEmpty && authorId.isNotEmpty && currentUserId == authorId) ||
        (profile != null && widget.item.author?.displayName == profile.displayName);

    final flowMap = ask['flow'] is Map ? ask['flow'] as Map : {};
    final typeMap = ask['type'] is Map ? ask['type'] as Map : {};
    final flowName = (flowMap['name'] ?? '').toString().trim();
    final typeName = (typeMap['name'] ?? typeMap['label'] ?? (flowName.isNotEmpty ? flowName : 'Collaboration')).toString().trim();
    final title = (ask['title'] ?? widget.item.contentText).toString().trim();

    final answers = ask['answers_by_key'] is Map ? ask['answers_by_key'] as Map : {};
    final rawTiming = (answers['help_timing'] ?? answers['timeline'] ?? ask['timeline'] ?? '').toString();
    final timingLabel = rawTiming.isNotEmpty ? _formatTiming(rawTiming) : 'This week';

    final creator = ask['creator'] is Map ? ask['creator'] as Map : {};
    final designation = (creator['designation'] ?? creator['company_name'] ?? widget.item.author?.designation ?? widget.item.author?.companyName ?? '').toString().trim();
    final city = (creator['city'] ?? creator['location'] ?? '').toString().split(',').first.trim();
    final responseCount = ask['response_count'] as num?;
    final responseStatus = responseCount != null && responseCount > 0 ? '$responseCount response${responseCount > 1 ? 's' : ''}' : 'No response yet';

    final metaSegments = [
      if (designation.isNotEmpty) designation,
      if (city.isNotEmpty) city,
      responseStatus,
    ];

    final isAmberTiming = timingLabel.toLowerCase().contains('week') || timingLabel.toLowerCase().contains('today');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimelineAuthorRow(
            author: widget.item.author,
            createdAt: widget.item.createdAt,
            onMoreTap: () => PostOptionsBottomSheet.show(context, item: widget.item),
            onAuthorTap: widget.onAuthorTap,
          ),
          const SizedBox(height: 12),
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (isFulfilled)
                _buildTag('Ask Fulfilled', AppColor.primaryBlue, AppColor.badgeBlueBg)
              else ...[
                if (flowName.isNotEmpty && flowName.toLowerCase() != typeName.toLowerCase())
                  _buildTag(flowName, isDark ? AppColor.primaryBlue : const Color(0xFF1E3A8A), isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFDBEAFE)),
                _buildTag(typeName, AppColor.primaryBlue, AppColor.badgeBlueBg),
                _buildTag(
                  timingLabel,
                  isAmberTiming ? const Color(0xFFB45309) : AppColor.primaryBlue,
                  isAmberTiming ? const Color(0xFFFEF3C7) : AppColor.badgeBlueBg,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title.isNotEmpty ? title : 'Collaboration Ask',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: primaryTextColor,
              height: 1.35,
            ),
          ),
          if (metaSegments.isNotEmpty && !isFulfilled) ...[
            const SizedBox(height: 4),
            Text(
              metaSegments.join(' · '),
              style: TextStyle(
                fontSize: 12.5,
                color: secondaryTextColor,
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (isFulfilled)
            Row(
              children: [
                _buildActionPill(
                  _isCongratulated ? 'Congratulated 🎉' : 'Congratulate',
                  _isCongratulated ? Icons.celebration : Icons.celebration_outlined,
                  _handleCongratulate,
                  isDark,
                  isHighlighted: _isCongratulated,
                ),
                const SizedBox(width: 8),
                _buildActionPill('Share', Icons.share_outlined, widget.onShareTap, isDark),
                const SizedBox(width: 8),
                _buildActionPill('Save', Icons.bookmark_outline, widget.onSaveTap, isDark),
              ],
            )
          else if (!isMyPost)
            SizedBox(
              height: 38,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColor.brandGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () => _onICanHelp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'I Can Help',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          TimelineInteractionBar(
            likesCount: widget.item.likesCount,
            commentsCount: widget.item.commentsCount,
            savesCount: widget.item.savesCount,
            isLiked: widget.item.isLikedByMe,
            isSaved: widget.item.isSaved,
            onLikeTap: widget.onLikeTap,
            onLikesCountTap: widget.onLikesCountTap,
            onCommentTap: widget.onCommentTap,
            onSaveTap: widget.onSaveTap,
            onShareTap: widget.onShareTap,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  Widget _buildActionPill(
    String label,
    IconData icon,
    VoidCallback? onTap,
    bool isDark, {
    bool isHighlighted = false,
  }) {
    final bgColor = isHighlighted
        ? null
        : (isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF1F5F9));
    final fgColor = isHighlighted
        ? Colors.white
        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155));
    final iconColor = isHighlighted
        ? Colors.white
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          gradient: isHighlighted ? AppColor.brandGradient : null,
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
