import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileOverviewCard extends StatefulWidget {
  final ProfileEntity profile;
  final VoidCallback onEditProfile;

  const ProfileOverviewCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  State<ProfileOverviewCard> createState() => _ProfileOverviewCardState();
}

class _ProfileOverviewCardState extends State<ProfileOverviewCard> {
  bool _isBioExpanded = false;

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final hasBio = profile.bio != null && profile.bio!.trim().isNotEmpty;
    final hasExperienceSummary =
        profile.experienceSummary != null && profile.experienceSummary!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio section if available
          if (hasBio || hasExperienceSummary) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColor.backgroundSubtle,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColor.borderSubtle.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        size: 16,
                        color: AppColor.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ABOUT ME',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasBio ? profile.bio! : profile.experienceSummary!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColor.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: _isBioExpanded ? null : 3,
                    overflow: _isBioExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  if ((hasBio && profile.bio!.length > 120) ||
                      (hasExperienceSummary && profile.experienceSummary!.length > 120)) ...[
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBioExpanded = !_isBioExpanded;
                        });
                      },
                      child: Text(
                        _isBioExpanded ? 'Show less' : 'Read more',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Professional Highlights Grid / List
          _buildInfoRow(
            icon: Icons.hub_outlined,
            title: 'Active Circle',
            value: profile.activeCircle?.name ?? 'Not assigned',
            accentColor: AppColor.primary,
          ),
          if (profile.businessType != null && profile.businessType!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs + 2),
            _buildInfoRow(
              icon: Icons.business_center_outlined,
              title: 'Business Type',
              value: profile.businessType!,
              accentColor: AppColor.primaryGradientEnd,
            ),
          ],
          if (profile.experienceYears != null) ...[
            const SizedBox(height: AppSpacing.xs + 2),
            _buildInfoRow(
              icon: Icons.workspace_premium_outlined,
              title: 'Experience',
              value: '${profile.experienceYears} Years',
              accentColor: const Color(0xFF10B981),
            ),
          ],
          if (profile.preferredLanguage != null && profile.preferredLanguage!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs + 2),
            _buildInfoRow(
              icon: Icons.translate_rounded,
              title: 'Preferred Language',
              value: profile.preferredLanguage!,
              accentColor: const Color(0xFF8B5CF6),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Edit Profile CTA button with Brand Gradient
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColor.brandGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onEditProfile,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColor.white,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Edit Profile',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color accentColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(
            icon,
            size: 15,
            color: accentColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColor.textTertiary,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
