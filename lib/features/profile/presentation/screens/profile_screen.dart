import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_posts_bloc.dart';
import '../bloc/profile_posts_event.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_overview_card.dart';
import '../widgets/profile_content_tabs.dart';
import '../widgets/profile_posts_tab.dart';
import '../widgets/profile_media_tab.dart';
import '../widgets/profile_about_tab.dart';
import '../widgets/profile_skeleton_loader.dart';
import 'edit_profile_overview_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileTab _selectedTab = ProfileTab.posts;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileFetchRequested());
    context.read<ProfilePostsBloc>().add(const ProfilePostsFetchRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<ProfileBloc>().add(const ProfileRefreshRequested());
    context.read<ProfilePostsBloc>().add(const ProfilePostsRefreshRequested());
  }

  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const EditProfileOverviewScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'My Profile',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColor.textPrimary),
            tooltip: 'Edit Profile',
            onPressed: _navigateToEditProfile,
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.profile == null) {
            return const ProfileSkeletonLoader();
          }

          if (state.status == ProfileStatus.failure && state.profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColor.textTertiary),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.errorMessage ?? 'Failed to load profile',
                      style: AppTypography.bodyMedium.copyWith(color: AppColor.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(const ProfileFetchRequested(forceRefresh: true));
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = state.profile;
          if (profile == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColor.primary,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Card
                  ProfileHeaderCard(
                    profile: profile,
                    onEditCover: _navigateToEditProfile,
                    onEditPhoto: _navigateToEditProfile,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Stats & Impact Row
                  ProfileStatsRow(profile: profile),
                  const SizedBox(height: AppSpacing.sm),

                  // Overview Card (Bio + Snapshot + Edit CTA)
                  ProfileOverviewCard(
                    profile: profile,
                    onEditProfile: _navigateToEditProfile,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Content Tabs (Posts | Media | About)
                  ProfileContentTabs(
                    selectedTab: _selectedTab,
                    onTabSelected: (tab) {
                      setState(() {
                        _selectedTab = tab;
                      });
                    },
                    postCount: profile.postsCount,
                    mediaCount: profile.media.length,
                  ),

                  // Active Tab Content
                  if (_selectedTab == ProfileTab.posts)
                    ProfilePostsTab(scrollController: _scrollController)
                  else if (_selectedTab == ProfileTab.media)
                    ProfileMediaTab(profile: profile)
                  else
                    ProfileAboutTab(profile: profile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
