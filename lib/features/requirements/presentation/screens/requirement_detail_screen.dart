import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/presentation/widgets/post_comments_bottom_sheet.dart';
import '../../domain/entities/requirement.dart';
import '../bloc/requirements_bloc.dart';
import '../bloc/requirements_event.dart';
import '../bloc/requirements_state.dart';
import '../widgets/requirement_share_helper.dart';

class RequirementDetailScreen extends StatelessWidget {
  final Requirement requirement;
  final bool isOwner;

  const RequirementDetailScreen({
    super.key,
    required this.requirement,
    this.isOwner = false,
  });

  String _formatDate(String dateString) => AppDateFormatter.format(dateString);

  void _openComments(BuildContext context) {
    final postId = requirement.postId ?? requirement.id;
    if (postId.isNotEmpty) {
      PostCommentsBottomSheet.show(context, postId: postId);
    }
  }

  void _onPeerTap(BuildContext context) {
    final userId = requirement.user?.id;
    if (userId == null || userId.isEmpty) return;
    final authUser = context.read<AuthBloc>().state.user;
    final myId = authUser?.id ?? '';
    if (myId.isNotEmpty && userId == myId) {
      Navigator.of(context).pushNamed(AppRoutes.profile);
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.peerProfile,
        arguments: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final tertiaryTextColor = isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final subtleSurface = isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle;

    final isOpen = requirement.isOpen;
    final user = requirement.user;
    final hasCompany =
        user?.company != null && user!.company!.trim().isNotEmpty;
    final hasCity =
        (user?.city != null && user!.city!.trim().isNotEmpty) ||
        (requirement.cityName != null &&
            requirement.cityName!.trim().isNotEmpty);
    final displayCity = (user?.city != null && user!.city!.trim().isNotEmpty)
        ? user.city!.trim()
        : (requirement.cityName ?? '');

    return BlocListener<RequirementsBloc, RequirementsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == RequirementsStatus.success ||
              curr.status == RequirementsStatus.error),
      listener: (context, state) {
        if (state.status == RequirementsStatus.success &&
            state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
        } else if (state.status == RequirementsStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppCommonBar(
          title: 'Ask Details',
          showBack: true,
          showSearch: false,
          showNotifications: false,
          showProfile: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20),
              onPressed: () =>
                  RequirementShareHelper.shareRequirement(requirement),
            ),
          ],
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main details card
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Header (Tappable for Peer Details)
                        InkWell(
                          onTap: () => _onPeerTap(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppAvatar(
                                  imageUrl: user?.avatar,
                                  name: user?.fullName ?? 'Peer',
                                  size: 42,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (user?.fullName ?? 'Peer Member')
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: primaryTextColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isOpen
                                                  ? AppColor.success.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : tertiaryTextColor
                                                        .withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(
                                                4,
                                              ),
                                            ),
                                            child: Text(
                                              requirement.status.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w500,
                                                color: isOpen
                                                    ? AppColor.success
                                                    : secondaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (hasCompany) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.business_center_rounded,
                                              size: 11,
                                              color: secondaryTextColor,
                                            ),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                user.company!.trim(),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: secondaryTextColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (hasCity) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              size: 11,
                                              color: secondaryTextColor,
                                            ),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                displayCity,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: secondaryTextColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: tertiaryTextColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(height: 1, color: borderColor),
                        const SizedBox(height: 12),

                        // Subject
                        Text(
                          requirement.subject,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Category and Location Tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if (requirement.category != null &&
                                requirement.category!.trim().isNotEmpty)
                              _buildTag(requirement.category!.trim()),
                            if (requirement.regionLabel != null &&
                                requirement.regionLabel!.trim().isNotEmpty)
                              _buildTag(requirement.regionLabel!.trim()),
                            if (requirement.cityName != null &&
                                requirement.cityName!.trim().isNotEmpty)
                              _buildTag(requirement.cityName!.trim()),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          requirement.description.trim(),
                          style: TextStyle(
                            fontSize: 12.5,
                            color: secondaryTextColor,
                            height: 1.45,
                          ),
                        ),

                        // Media Attachments
                        if (requirement.media.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            'Attachments',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...requirement.media.map(
                            (m) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      m.url != null && m.url!.startsWith('http')
                                      ? m.url!
                                      : '${ApiEndpoints.baseUrl}/files/${m.id}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180,
                                  placeholder: (_, _) => Container(
                                    height: 180,
                                    color: subtleSurface,
                                  ),
                                  errorWidget: (_, _, _) => Container(
                                    height: 100,
                                    color: subtleSurface,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        color: tertiaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),
                        Text(
                          'Submitted on ${_formatDate(requirement.submittedAt)}',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: tertiaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Comments & Discussion Tile
                  InkWell(
                    onTap: () => _openComments(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                            color: AppColor.primaryBlue,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Comments & Discussion',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Owner complete action
                  if (isOwner && isOpen) ...[
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<RequirementsBloc>().add(
                          CompleteRequirementEvent(requirement.id),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text(
                        'Mark as Completed',
                        style: TextStyle(fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
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
              fontSize: 10.5,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
