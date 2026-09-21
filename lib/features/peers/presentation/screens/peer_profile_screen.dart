import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/peers/presentation/widgets/peer_profile/peer_introduced_peers_card.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/peer_profile_bloc.dart';
import '../bloc/peer_profile_event.dart';
import '../bloc/peer_profile_state.dart';
import '../widgets/peer_profile/peer_profile_actions.dart';
import '../widgets/peer_profile/peer_profile_business_card.dart';
import '../widgets/peer_profile/peer_profile_chips_card.dart';
import '../widgets/peer_profile/peer_profile_contact_card.dart';
import '../widgets/peer_profile/peer_profile_header.dart';
import '../widgets/peer_profile/peer_profile_posts_section.dart';
import '../widgets/peer_profile/peer_profile_skeleton_loader.dart';
import '../widgets/peer_profile/peer_profile_stats.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../profile/presentation/bloc/profile_posts_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_event.dart';
import '../../../profile/presentation/widgets/profile_circles_card.dart';
import '../../../profile/presentation/widgets/profile_share_card_sheet.dart';
import '../../../testimonials/domain/usecases/get_given_testimonials_usecase.dart';
import '../../../testimonials/domain/usecases/get_received_testimonials_usecase.dart';
import '../../../testimonials/domain/usecases/get_user_testimonials_usecase.dart';
import '../../../testimonials/presentation/bloc/testimonials_bloc.dart';
import '../../../testimonials/presentation/bloc/testimonials_event.dart';
import '../../../testimonials/presentation/widgets/testimonials_card.dart';

class PeerProfileScreen extends StatelessWidget {
  final String peerId;
  const PeerProfileScreen({super.key, required this.peerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TestimonialsBloc(
        getReceivedTestimonialsUseCase: ctx
            .read<GetReceivedTestimonialsUseCase>(),
        getGivenTestimonialsUseCase: ctx.read<GetGivenTestimonialsUseCase>(),
        getUserTestimonialsUseCase: ctx.read<GetUserTestimonialsUseCase>(),
      )..add(TestimonialsFetchUserRequested(peerId)),
      child: _PeerProfileView(peerId: peerId),
    );
  }
}

class _PeerProfileView extends StatefulWidget {
  final String peerId;
  const _PeerProfileView({required this.peerId});

  @override
  State<_PeerProfileView> createState() => _PeerProfileViewState();
}

class _PeerProfileViewState extends State<_PeerProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<PeerProfileBloc>().add(
      PeerProfileFetchRequested(widget.peerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeerProfileBloc, PeerProfileState>(
      buildWhen: (prev, curr) =>
          prev.profile?.displayName != curr.profile?.displayName,
      builder: (context, state) {
        final title = state.profile?.displayName.toUpperCase() ?? 'PEER';
        return Scaffold(
          backgroundColor: AppColor.lightBackground,
          appBar: AppCommonBar(
            title: title,
            showBack: true,
            showSearch: false,
            showNotifications: false,
            showProfile: false,
            showChat: false,
            onBackTap: () => Navigator.pop(context),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () => _showOptionsSheet(context),
              ),
            ],
          ),
          body: BlocConsumer<PeerProfileBloc, PeerProfileState>(
            listener: (context, state) {
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty &&
                  !state.isBlocked) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) => _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PeerProfileState state) {
    if (state.status == PeerProfileStatus.loading ||
        state.status == PeerProfileStatus.initial) {
      return const PeerProfileSkeletonLoader();
    }
    final bloc = context.read<PeerProfileBloc>();

    if (state.isBlocked) {
      final name = state.profile?.displayName ?? 'Peer';
      final avatar = state.profile?.profilePhotoUrl;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null && avatar.isNotEmpty)
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(avatar),
                  backgroundColor: AppColor.lightSurfaceSubtle,
                )
              else
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block_flipped,
                    size: 36,
                    color: AppColor.error,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You have blocked this peer.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.error,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'You cannot view their profile details, activity, or contact them.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: state.isBlockLoading
                    ? null
                    : () => _confirmUnblock(context, bloc),
                icon: state.isBlockLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.lock_open_rounded, size: 18),
                label: const Text(
                  'Unblock Peer',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.status == PeerProfileStatus.failure || state.profile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColor.lightTextSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Failed to load profile',
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<PeerProfileBloc>().add(
                PeerProfileFetchRequested(widget.peerId),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    final profile = state.profile!;
    final isBlocked = state.isBlocked || profile.isBlocked;

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async {
        bloc.add(PeerProfileFetchRequested(widget.peerId));
        context.read<TestimonialsBloc>().add(
          TestimonialsFetchUserRequested(widget.peerId),
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            PeerProfileHeader(
              profile: profile,
              onBookmarkToggle: () =>
                  bloc.add(const PeerProfileBookmarkToggled()),
            ),
            const SizedBox(height: 12),
            PeerProfileActions(
              profile: isBlocked ? profile.copyWith(isBlocked: true) : profile,
              onConnect: () => bloc.add(const PeerProfileConnectRequested()),
              onCancelRequest: () =>
                  bloc.add(const PeerProfileCancelRequestRequested()),
              onFollowToggle: () => bloc.add(const PeerProfileFollowToggled()),
            ),
            const SizedBox(height: 10),
            PeerProfileStats(profile: profile),
            const SizedBox(height: 10),
            PeerProfileContactCard(profile: profile),
            const SizedBox(height: 10),
            PeerProfileBusinessCard(profile: profile),
            if (profile.circleMemberships.isNotEmpty ||
                profile.activeCircle != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProfileCirclesCard(profile: profile),
              ),
            ],
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PeerIntroducedPeersCard(
                peerId: profile.id,
                peerName: profile.displayName,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TestimonialsCard(
                peerId: profile.id,
                peerName: profile.displayName,
              ),
            ),
            if (profile.skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              PeerProfileChipsCard(
                icon: Icons.bar_chart_rounded,
                iconColor: AppColor.primaryBlue,
                title: 'Skills',
                items: profile.skills,
              ),
            ],
            if (profile.interests.isNotEmpty) ...[
              const SizedBox(height: 10),
              PeerProfileChipsCard(
                icon: Icons.favorite_rounded,
                iconColor: const Color(0xFFE91E63),
                title: 'Interests',
                items: profile.interests,
              ),
            ],
            const SizedBox(height: 10),
            PeerProfilePostsSection(
              profile: profile,
              posts: state.posts,
              isLoading: state.isPostsLoading,
              hasMore: state.hasMorePosts,
              isLoadingMore: state.isLoadingMorePosts,
              onLoadMore: () =>
                  bloc.add(const PeerProfilePostsLoadMoreRequested()),
              onLikeTap: (id) {
                final matches = state.posts.where((p) => p.id == id);
                if (matches.isNotEmpty) {
                  final post = matches.first;
                  final currentLiked = post.isLikedByMe;
                  final newLiked = !currentLiked;
                  final newCount = (post.likesCount + (newLiked ? 1 : -1))
                      .clamp(0, 9999999);
                  bloc.add(PeerProfilePostLikeToggled(id));
                  try {
                    context.read<HomeBloc>().add(
                      HomePostLikeSyncRequested(
                        postId: id,
                        isLiked: newLiked,
                        likesCount: newCount,
                      ),
                    );
                  } catch (_) {}
                  try {
                    context.read<ProfilePostsBloc>().add(
                      ProfilePostLikeSyncRequested(
                        postId: id,
                        isLiked: newLiked,
                        likesCount: newCount,
                      ),
                    );
                  } catch (_) {}
                } else {
                  bloc.add(PeerProfilePostLikeToggled(id));
                }
              },
              onSaveTap: (id) {
                final matches = state.posts.where((p) => p.id == id);
                if (matches.isNotEmpty) {
                  final post = matches.first;
                  final newSaved = !post.isSaved;
                  bloc.add(PeerProfilePostSaveToggled(id));
                  try {
                    context.read<HomeBloc>().add(
                      HomePostSaveSyncRequested(postId: id, isSaved: newSaved),
                    );
                  } catch (_) {}
                  try {
                    context.read<ProfilePostsBloc>().add(
                      ProfilePostSaveSyncRequested(
                        postId: id,
                        isSaved: newSaved,
                      ),
                    );
                  } catch (_) {}
                } else {
                  bloc.add(PeerProfilePostSaveToggled(id));
                }
              },
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                'assets/images/end_screen_image.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    final bloc = context.read<PeerProfileBloc>();
    final profile = bloc.state.profile;
    final isBlocked = bloc.state.isBlocked || (profile?.isBlocked ?? false);
    final isConnected =
        profile != null &&
        (profile.isConnected ||
            profile.connectionStatus.toLowerCase() == 'connected');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.share_outlined,
                color: AppColor.lightTextPrimary,
              ),
              title: const Text(
                'Share Profile',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              onTap: () {
                Navigator.pop(ctx);
                if (profile != null) {
                  ProfileShareCardSheet.show(context, profile: profile);
                }
              },
            ),
            if (isConnected)
              ListTile(
                leading: const Icon(
                  Icons.person_remove_outlined,
                  color: AppColor.error,
                ),
                title: const Text(
                  'Remove Connection',
                  style: TextStyle(
                    color: AppColor.error,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmRemoveConnection(context, bloc);
                },
              ),
            if (isBlocked)
              ListTile(
                leading: const Icon(
                  Icons.lock_open_rounded,
                  color: AppColor.primaryBlue,
                ),
                title: const Text(
                  'Unblock Peer',
                  style: TextStyle(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmUnblock(context, bloc);
                },
              )
            else
              ListTile(
                leading: const Icon(
                  Icons.block_flipped,
                  color: AppColor.error,
                ),
                title: const Text(
                  'Block Peer',
                  style: TextStyle(
                    color: AppColor.error,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmBlock(context, bloc);
                },
              ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: AppColor.error),
              title: const Text(
                'Report User',
                style: TextStyle(
                  color: AppColor.error,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                AppSnackBar.showInfo(context, 'Report submitted');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBlock(BuildContext context, PeerProfileBloc bloc) {
    final name = bloc.state.profile?.displayName ?? 'this peer';
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text(
          'Block Peer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        content: Text(
          'Are you sure you want to block $name? They will no longer be able to message you or view your profile updates.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColor.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dCtx);
              bloc.add(const PeerProfileBlockRequested(reason: 'Spam messages'));
            },
            child: const Text(
              'Block',
              style: TextStyle(
                color: AppColor.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmUnblock(BuildContext context, PeerProfileBloc bloc) {
    final name = bloc.state.profile?.displayName ?? 'this peer';
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text(
          'Unblock Peer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        content: Text(
          'Are you sure you want to unblock $name? They will be able to view your profile and interact with you.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColor.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dCtx);
              bloc.add(const PeerProfileUnblockRequested());
            },
            child: const Text(
              'Unblock',
              style: TextStyle(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveConnection(BuildContext context, PeerProfileBloc bloc) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text(
          'Remove Connection',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        content: Text(
          'Are you sure you want to remove ${bloc.state.profile?.displayName ?? "this user"} from your connections?',
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColor.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dCtx);
              bloc.add(const PeerProfileRemoveConnectionRequested());
            },
            child: const Text(
              'Remove',
              style: TextStyle(
                color: AppColor.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
