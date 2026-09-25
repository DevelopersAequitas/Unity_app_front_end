import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/video_cache_service.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/support_prompt_sheet.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/shorts_bloc.dart';
import '../bloc/shorts_event.dart';
import '../bloc/shorts_state.dart';
import '../widgets/shorts_add_video_prompt.dart';
import '../widgets/shorts_empty_view.dart';
import '../widgets/shorts_video_card.dart';

class ShortsScreen extends StatefulWidget {
  final bool showBackButton;
  final bool isVisible;

  const ShortsScreen({
    super.key,
    this.showBackButton = false,
    this.isVisible = true,
  });

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen>
    with WidgetsBindingObserver, RouteAware {
  late final PageController _pageController;
  bool _isMuted = false;
  bool _promptDismissed = false;
  bool _isAppInForeground = true;
  bool _isTopRoute = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();
    final bloc = context.read<ShortsBloc>();
    if (bloc.state.status == ShortsStatus.initial) {
      bloc.add(const FetchIntroVideosEvent());
    } else if (bloc.state.videos.isNotEmpty) {
      final urls = bloc.state.videos.map((v) => v.introVideoUrl).toList();
      VideoCacheService().preloadAdjacentVideos(
        urls,
        bloc.state.currentIndex % bloc.state.videos.length,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      AppRouter.routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isAppInForeground = state == AppLifecycleState.resumed;
    });
  }

  @override
  void didPushNext() {
    if (mounted) setState(() => _isTopRoute = false);
  }

  @override
  void didPopNext() {
    if (mounted) setState(() => _isTopRoute = true);
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileBloc>().state.profile;
    final hasMyVideo =
        profile?.profileVideoUrl != null &&
        profile!.profileVideoUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BlocConsumer<ShortsBloc, ShortsState>(
            listenWhen: (previous, current) =>
                previous.videos != current.videos && current.videos.isNotEmpty,
            listener: (context, state) {
              final urls = state.videos.map((v) => v.introVideoUrl).toList();
              VideoCacheService().preloadAdjacentVideos(
                urls,
                state.currentIndex % state.videos.length,
              );
            },
            builder: (context, state) {
              if (state.status == ShortsStatus.loading &&
                  state.videos.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.primaryBlue),
                );
              }

              if (state.status == ShortsStatus.error && state.videos.isEmpty) {
                return _buildErrorState(context);
              }

              if (state.videos.isEmpty) {
                return const ShortsEmptyView();
              }

              final isLooping = state.videos.length > 1;
              final itemCount = isLooping
                  ? state.videos.length * 1000
                  : state.videos.length;

              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context.read<ShortsBloc>().add(
                    const FetchIntroVideosEvent(isRefresh: true),
                  );
                },
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: itemCount,
                  onPageChanged: (index) {
                    final actualIndex = index % state.videos.length;
                    context.read<ShortsBloc>().add(
                      ShortsPageChangedEvent(actualIndex),
                    );
                    final urls = state.videos
                        .map((v) => v.introVideoUrl)
                        .toList();
                    VideoCacheService().preloadAdjacentVideos(
                      urls,
                      actualIndex,
                    );
                  },
                  itemBuilder: (context, index) {
                    final actualIndex = index % state.videos.length;
                    final video = state.videos[actualIndex];
                    final isPlaybackActive =
                        widget.isVisible &&
                        _isAppInForeground &&
                        _isTopRoute &&
                        actualIndex ==
                            (state.currentIndex % state.videos.length);

                    return ShortsVideoCard(
                      key: ValueKey('${video.id}_$index'),
                      video: video,
                      isActive: isPlaybackActive,
                      isMuted: _isMuted,
                      onToggleMute: _toggleMute,
                      onToggleLike: () {
                        context.read<ShortsBloc>().add(
                          ToggleShortLikeEvent(video.id),
                        );
                      },
                      onToggleBookmark: () {
                        context.read<ShortsBloc>().add(
                          ToggleShortBookmarkEvent(video.userId),
                        );
                      },
                      onToggleFollow: () {
                        context.read<ShortsBloc>().add(
                          ToggleShortFollowEvent(video.userId),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          if (!hasMyVideo && !_promptDismissed)
            Positioned(
              top:
                  MediaQuery.of(context).padding.top +
                  (widget.showBackButton ? 48 : 12),
              left: 16,
              right: 16,
              child: ShortsAddVideoPrompt(
                onDismiss: () => setState(() => _promptDismissed = true),
              ),
            ),
          if (widget.showBackButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColor.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 34,
                  color: AppColor.error,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'Unable to Load Intro Videos',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Unable to load data. Please check your internet connection and try again.',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white54,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Retry button
            SizedBox(
              width: 200,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => context.read<ShortsBloc>().add(
                  const FetchIntroVideosEvent(isRefresh: true),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  'Retry',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Help & Support button – styled for dark background
            SizedBox(
              width: 200,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () => SupportPromptSheet.show(
                  context,
                  screenName: 'Intro Videos',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.help_outline_rounded,
                  size: 16,
                  color: Colors.white54,
                ),
                label: Text(
                  'Help & Support',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
