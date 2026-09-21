import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/domain/entities/timeline_author_entity.dart';
import '../../../home/presentation/widgets/post_comments_bottom_sheet.dart';
import '../../../home/presentation/widgets/timeline_author_row.dart';
import '../../domain/entities/requirement.dart';
import '../screens/requirement_detail_screen.dart';
import 'requirement_share_helper.dart';

class RequirementCard extends StatelessWidget {
  final Requirement requirement;
  final bool isOwner;
  final VoidCallback? onComplete;
  final EdgeInsetsGeometry? margin;

  const RequirementCard({
    super.key,
    required this.requirement,
    this.isOwner = false,
    this.onComplete,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final isOpen = requirement.isOpen;
    final user = requirement.user;

    final author = TimelineAuthorEntity(
      id: user?.id ?? '',
      displayName: user?.fullName ?? 'Peers Member',
      profilePhotoUrl: user?.avatar,
      companyName: user?.company,
      designation: (user?.city?.isNotEmpty == true) ? user!.city! : requirement.cityName,
      level4Category: requirement.category,
    );

    final postId = requirement.postId ?? requirement.id;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RequirementDetailScreen(
                  requirement: requirement,
                  isOwner: isOwner,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Author Row (Matching Home Tab exactly)
                TimelineAuthorRow(
                  author: author,
                  createdAt: requirement.submittedAt,
                  onAuthorTap: () {
                    final authorId = author.id;
                    if (authorId.isEmpty) return;
                    final authUser = context.read<AuthBloc>().state.user;
                    final myId = authUser?.id ?? '';
                    if (myId.isNotEmpty && authorId == myId) {
                      Navigator.of(context).pushNamed(AppRoutes.profile);
                    } else {
                      Navigator.of(context).pushNamed(
                        AppRoutes.peerProfile,
                        arguments: authorId,
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Requirement Subject
                Text(
                  requirement.subject,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Requirement Description
                if (requirement.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    requirement.description.trim(),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: secondaryTextColor,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Region & Location Tags
                if ((requirement.regionLabel != null && requirement.regionLabel!.trim().isNotEmpty) ||
                    (requirement.cityName != null && requirement.cityName!.trim().isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (requirement.regionLabel != null && requirement.regionLabel!.trim().isNotEmpty)
                        _buildTag(requirement.regionLabel!.trim(), isDark),
                      if (requirement.cityName != null && requirement.cityName!.trim().isNotEmpty)
                        _buildTag(requirement.cityName!.trim(), isDark),
                    ],
                  ),
                ],

                // Media thumbnail preview if present
                if (requirement.media.isNotEmpty && requirement.media.first.url != null) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: requirement.media.first.url!.startsWith('http')
                          ? requirement.media.first.url!
                          : '${ApiEndpoints.baseUrl}/files/${requirement.media.first.id}',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        height: 120,
                        color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
                      ),
                      errorWidget: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Footer Row: Comments action + Status badge
                Row(
                  children: [
                    // Comments button
                    InkWell(
                      onTap: () {
                        if (postId.isNotEmpty) {
                          PostCommentsBottomSheet.show(
                            context,
                            postId: postId,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 16,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Comment',
                              style: TextStyle(
                                fontSize: 11,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Share button
                    InkWell(
                      onTap: () => RequirementShareHelper.shareRequirement(requirement),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.share_outlined,
                              size: 16,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Share',
                              style: TextStyle(
                                fontSize: 11,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? AppColor.success.withValues(alpha: 0.1)
                            : secondaryTextColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        requirement.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: isOpen ? AppColor.success : secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),

                // Owner action if needed
                if (isOwner && isOpen && onComplete != null) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.check_circle_outline, size: 14),
                      label: const Text('Mark as Completed', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.success,
                        side: const BorderSide(color: AppColor.success),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.borderSubtle,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
