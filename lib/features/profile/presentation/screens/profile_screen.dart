import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/image_source_picker_sheet.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_posts_bloc.dart';
import '../bloc/profile_posts_event.dart';
import '../bloc/profile_saved_posts_bloc.dart';
import '../bloc/profile_saved_posts_event.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_membership_card.dart';
import '../widgets/profile_circles_card.dart';
import '../widgets/profile_introduced_peers_card.dart';
import '../widgets/profile_content_tabs.dart';
import '../widgets/profile_posts_tab.dart';
import '../widgets/profile_saved_posts_tab.dart';
import '../widgets/profile_about_tab.dart';
import '../widgets/profile_skeleton_loader.dart';
import '../widgets/profile_share_card_sheet.dart';
import 'edit_profile_overview_screen.dart';
import '../../../highlights/presentation/bloc/top_builders/top_builders_bloc.dart';
import '../../../highlights/presentation/bloc/top_builders/top_builders_event.dart';
import '../../../testimonials/domain/usecases/get_given_testimonials_usecase.dart';
import '../../../testimonials/domain/usecases/get_received_testimonials_usecase.dart';
import '../../../testimonials/domain/usecases/get_user_testimonials_usecase.dart';
import '../../../testimonials/presentation/bloc/testimonials_bloc.dart';
import '../../../testimonials/presentation/bloc/testimonials_event.dart';
import '../../../testimonials/presentation/widgets/testimonials_card.dart';
import '../../../menu/presentation/bloc/menu_bloc.dart';
import '../../../menu/presentation/bloc/menu_state.dart';
import '../../../menu/presentation/screens/menu_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TestimonialsBloc(
        getReceivedTestimonialsUseCase: ctx.read<GetReceivedTestimonialsUseCase>(),
        getGivenTestimonialsUseCase: ctx.read<GetGivenTestimonialsUseCase>(),
        getUserTestimonialsUseCase: ctx.read<GetUserTestimonialsUseCase>(),
      )..add(const TestimonialsFetchReceivedRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  ProfileTab _selectedTab = ProfileTab.posts;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileFetchRequested());
    context.read<ProfilePostsBloc>().add(const ProfilePostsFetchRequested());
    context.read<ProfileSavedPostsBloc>().add(const ProfileSavedPostsFetchRequested());
    context.read<TopBuildersBloc>().add(const FetchTopBuildersDataEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<ProfileBloc>().add(const ProfileRefreshRequested());
    context.read<ProfilePostsBloc>().add(const ProfilePostsRefreshRequested());
    context.read<ProfileSavedPostsBloc>().add(const ProfileSavedPostsRefreshRequested());
    context.read<TopBuildersBloc>().add(const FetchTopBuildersDataEvent(isRefresh: true));
    context.read<TestimonialsBloc>().add(const TestimonialsFetchReceivedRequested());
  }

  Future<void> _handleEditPhoto({required bool isCover}) async {
    if (!OfflineGuard.check(context, actionName: 'update your profile photos')) return;
    final croppedFile = isCover
        ? await ImageSourcePickerSheet.showCoverPhotoCropper(context)
        : await ImageSourcePickerSheet.showProfilePhotoCropper(context);

    if (croppedFile != null && mounted) {
      context.read<ProfileEditBloc>().add(
            ProfileUploadPhotoRequested(
              file: File(croppedFile.path),
              isCover: isCover,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updating ${isCover ? "cover banner" : "profile photo"}...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToEditProfile() {
    if (!OfflineGuard.check(context, actionName: 'edit your profile')) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileOverviewScreen()),
    );
  }

  void _navigateToMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final textPrimary = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final profile = state.profile;
              if (profile == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.share_outlined, size: 20, color: AppColor.lightTextPrimary),
                onPressed: () => ProfileShareCardSheet.show(
                  context,
                  profile: profile,
                  isOwnProfile: true,
                ),
              );
            },
          ),
          BlocBuilder<MenuBloc, MenuState>(
            builder: (context, menuState) {
              final count = menuState.summary.meetingRequestsCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    tooltip: 'Menu',
                    icon: const Icon(Icons.menu_rounded, size: 22, color: AppColor.lightTextPrimary),
                    onPressed: _navigateToMenu,
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColor.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          count > 9 ? '9+' : count.toString(),
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AppGradientBackground(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading && state.profile == null) {
              return const ProfileSkeletonLoader();
            }

            if (state.status == ProfileStatus.failure && state.profile == null) {
              return _buildErrorState(state.errorMessage);
            }

            final profile = state.profile;
            if (profile == null) return const SizedBox.shrink();

            return RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColor.primaryBlue,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUploadProgressBanner(),
                    ProfileHeaderCard(
                      profile: profile,
                      onEditCover: () => _handleEditPhoto(isCover: true),
                      onEditPhoto: () => _handleEditPhoto(isCover: false),
                      onEditProfile: _navigateToEditProfile,
                    ),
                    const SizedBox(height: 12),
                    ProfileStatsRow(profile: profile),
                    const SizedBox(height: 12),
                    ProfileMembershipCard(profile: profile),
                    const SizedBox(height: 12),
                    ProfileCirclesCard(profile: profile),
                    const SizedBox(height: 12),
                    const ProfileIntroducedPeersCard(),
                    const SizedBox(height: 12),
                    TestimonialsCard(
                      peerId: profile.id,
                      peerName: profile.displayName,
                      isOwnProfile: true,
                    ),
                    const SizedBox(height: 12),
                    ProfileContentTabs(
                      selectedTab: _selectedTab,
                      onTabSelected: (tab) => setState(() => _selectedTab = tab),
                      postCount: profile.postsCount,
                    ),
                    const SizedBox(height: 12),
                    if (_selectedTab == ProfileTab.posts)
                      ProfilePostsTab(scrollController: _scrollController)
                    else if (_selectedTab == ProfileTab.saved)
                      ProfileSavedPostsTab(scrollController: _scrollController)
                    else
                      ProfileAboutTab(profile: profile),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUploadProgressBanner() {
    return BlocBuilder<ProfileEditBloc, ProfileEditState>(
      builder: (context, editState) {
        if (editState.status != ProfileEditStatus.uploading) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Updating ${editState.uploadType ?? "Media"}... Please wait',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const LinearProgressIndicator(
                backgroundColor: AppColor.lightSurfaceSubtle,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                minHeight: 3,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return AppErrorView(
      title: 'Unable to Load Profile',
      message: errorMessage,
      onRetry: () => context
          .read<ProfileBloc>()
          .add(const ProfileFetchRequested(forceRefresh: true)),
      screenName: 'My Profile',
    );
  }
}
