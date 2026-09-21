import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gradient_background.dart';
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

class EditProfileOverviewScreen extends StatelessWidget {
  const EditProfileOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final textPrimary = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: textPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: AppGradientBackground(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final profile = state.profile;
            if (profile == null) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.primaryBlue,
                  ),
                ),
              );
            }

            final c = state.completeness;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCompletionCard(percentage: c.overallPercentage),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 4,
                    ),
                    child: Text(
                      'PROFILE SECTIONS',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.lightTextTertiary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 1. Personal Information
                  ProfileSectionTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    subtitle: 'Name, contact, location & bio',
                    completionPercentage: c.personalPercentage,
                    accentColor: AppColor.primaryBlue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EditPersonalInfoScreen(profile: profile),
                        ),
                      );
                    },
                  ),

                  // 2. Business Information
                  ProfileSectionTile(
                    icon: Icons.business_center_outlined,
                    title: 'Business Information',
                    subtitle: 'Company, designation, category & revenue',
                    completionPercentage: c.businessPercentage,
                    accentColor: AppColor.primaryPink,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EditBusinessInfoScreen(profile: profile),
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
                          builder: (_) =>
                              EditProfessionalJourneyScreen(profile: profile),
                        ),
                      );
                    },
                  ),

                  // 4. Interests & Goals
                  ProfileSectionTile(
                    icon: Icons.emoji_objects_outlined,
                    title: 'Interests & Goals',
                    subtitle: 'Collaboration goals & networking',
                    completionPercentage: c.interestsPercentage,
                    accentColor: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EditInterestsGoalsScreen(profile: profile),
                        ),
                      );
                    },
                  ),

                  // 5. Social & Links
                  ProfileSectionTile(
                    icon: Icons.share_outlined,
                    title: 'Social & Links',
                    subtitle: 'LinkedIn, website & social handles',
                    completionPercentage: c.socialPercentage,
                    accentColor: const Color(0xFF0284C7),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EditSocialLinksScreen(profile: profile),
                        ),
                      );
                    },
                  ),

                  // 6. Media & Portfolio
                  ProfileSectionTile(
                    icon: Icons.perm_media_outlined,
                    title: 'Media & Portfolio',
                    subtitle: 'Intro video, creative & portfolio',
                    completionPercentage: c.mediaPercentage,
                    accentColor: const Color(0xFF8B5CF6),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EditMediaPortfolioScreen(profile: profile),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
