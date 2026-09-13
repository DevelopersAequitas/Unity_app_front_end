import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../profile/domain/entities/profile_entity.dart';

class CreatePostUserHeader extends StatelessWidget {
  final ProfileEntity? profile;
  final bool isDark;

  const CreatePostUserHeader({
    super.key,
    required this.profile,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final userDisplayName = profile?.displayName ?? 'You';
    final userPhotoUrl = profile?.profilePhotoUrl ?? '';
    final userDesignation = profile?.designation;
    final userCompany = profile?.companyName;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
          backgroundImage: userPhotoUrl.isNotEmpty ? NetworkImage(userPhotoUrl) : null,
          child: userPhotoUrl.isEmpty
              ? Text(
                  userDisplayName.isNotEmpty ? userDisplayName[0].toUpperCase() : 'U',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userDisplayName,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  if (userDesignation != null && userDesignation.isNotEmpty) ...[
                    Flexible(
                      child: Text(
                        userCompany != null && userCompany.isNotEmpty
                            ? '$userDesignation • $userCompany'
                            : userDesignation,
                        style: AppTypography.labelSmall.copyWith(
                          color: secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.darkBorder : AppColor.lightBorder.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.public_rounded,
                          size: 10,
                          color: secondaryTextColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Public',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            color: secondaryTextColor,
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
      ],
    );
  }
}
