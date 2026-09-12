import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_completion_card.dart';
import '../widgets/profile_section_tile.dart';
import 'edit_personal_info_screen.dart';
import 'edit_business_info_screen.dart';
import 'edit_professional_journey_screen.dart';
import 'edit_interests_goals_screen.dart';
import 'edit_social_links_screen.dart';
import 'edit_media_portfolio_screen.dart';
import 'edit_circle_membership_screen.dart';
import 'edit_additional_info_screen.dart';

class EditProfileOverviewScreen extends StatelessWidget {
  const EditProfileOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final c = state.completeness;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xs),
                // Overall Completeness
                ProfileCompletionCard(percentage: c.overallPercentage),
                const SizedBox(height: AppSpacing.xs),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  child: Text(
                    'PROFILE SECTIONS',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.textTertiary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // 1. Personal Information
                ProfileSectionTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal Information',
                  subtitle: 'Basic contact & location details',
                  completionPercentage: c.personalPercentage,
                  accentColor: AppColor.primary,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditPersonalInfoScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 2. Business Information
                ProfileSectionTile(
                  icon: Icons.business_center_outlined,
                  title: 'Business Information',
                  subtitle: 'Company details, revenue & categories',
                  completionPercentage: c.businessPercentage,
                  accentColor: AppColor.primaryGradientEnd,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditBusinessInfoScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 3. Professional Journey
                ProfileSectionTile(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Professional Journey',
                  subtitle: 'Experience, skills & achievements',
                  completionPercentage: c.professionalPercentage,
                  accentColor: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditProfessionalJourneyScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 4. Interests & Goals
                ProfileSectionTile(
                  icon: Icons.emoji_objects_outlined,
                  title: 'Interests & Goals',
                  subtitle: 'Networking goals & collaboration intents',
                  completionPercentage: c.interestsPercentage,
                  accentColor: const Color(0xFFF59E0B),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditInterestsGoalsScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 5. Social & Links
                ProfileSectionTile(
                  icon: Icons.share_outlined,
                  title: 'Social & Links',
                  subtitle: 'LinkedIn, Instagram, website & channels',
                  completionPercentage: c.socialPercentage,
                  accentColor: const Color(0xFF0284C7),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditSocialLinksScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 6. Media & Portfolio
                ProfileSectionTile(
                  icon: Icons.perm_media_outlined,
                  title: 'Media & Portfolio',
                  subtitle: 'Photos, videos & portfolio assets',
                  completionPercentage: c.mediaPercentage,
                  accentColor: const Color(0xFF8B5CF6),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditMediaPortfolioScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 7. Circle & Membership
                ProfileSectionTile(
                  icon: Icons.hub_outlined,
                  title: 'Circle & Membership',
                  subtitle: 'Active circle, validity & category details',
                  completionPercentage: c.circlePercentage,
                  accentColor: const Color(0xFFEC4899),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditCircleMembershipScreen(profile: profile),
                      ),
                    );
                  },
                ),

                // 8. Additional Information
                ProfileSectionTile(
                  icon: Icons.more_horiz_rounded,
                  title: 'Additional Information',
                  subtitle: 'Bio, superpower & community preferences',
                  completionPercentage: c.additionalPercentage,
                  accentColor: const Color(0xFF64748B),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditAdditionalInfoScreen(profile: profile),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Tip Box
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColor.primary.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates_outlined, size: 20, color: AppColor.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Having an updated profile increases your trust score & network visibility across the community.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColor.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
