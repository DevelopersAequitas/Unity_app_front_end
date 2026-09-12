import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
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
import '../widgets/peer_profile/peer_profile_stats.dart';

class PeerProfileScreen extends StatefulWidget {
  final String peerId;
  const PeerProfileScreen({super.key, required this.peerId});

  @override
  State<PeerProfileScreen> createState() => _PeerProfileScreenState();
}

class _PeerProfileScreenState extends State<PeerProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PeerProfileBloc>().add(PeerProfileFetchRequested(widget.peerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColor.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<PeerProfileBloc, PeerProfileState>(
          builder: (context, state) => Text(
            state.profile?.displayName.toUpperCase() ?? 'PEER PROFILE',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: AppColor.lightTextPrimary),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColor.lightTextPrimary),
            onPressed: () => _showOptionsSheet(context),
          ),
        ],
      ),
      body: BlocConsumer<PeerProfileBloc, PeerProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            AppSnackBar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PeerProfileState state) {
    if (state.status == PeerProfileStatus.loading || state.status == PeerProfileStatus.initial) {
      return const Center(child: CircularProgressIndicator(color: AppColor.primaryBlue));
    }
    if (state.status == PeerProfileStatus.failure || state.profile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColor.lightTextSecondary),
            const SizedBox(height: 12),
            Text(state.errorMessage ?? 'Failed to load profile', style: const TextStyle(fontSize: 14, color: AppColor.lightTextSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<PeerProfileBloc>().add(PeerProfileFetchRequested(widget.peerId)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue, foregroundColor: Colors.white),
              child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    }

    final profile = state.profile!;
    final bloc = context.read<PeerProfileBloc>();

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => bloc.add(PeerProfileFetchRequested(widget.peerId)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            PeerProfileHeader(profile: profile, onBookmarkToggle: () => bloc.add(const PeerProfileBookmarkToggled())),
            const SizedBox(height: 12),
            PeerProfileActions(
              profile: profile,
              onConnect: () => bloc.add(const PeerProfileConnectRequested()),
              onCancelRequest: () => bloc.add(const PeerProfileCancelRequestRequested()),
              onFollowToggle: () => bloc.add(const PeerProfileFollowToggled()),
            ),
            const SizedBox(height: 10),
            PeerProfileStats(profile: profile),
            const SizedBox(height: 10),
            PeerProfileContactCard(profile: profile),
            const SizedBox(height: 10),
            PeerProfileBusinessCard(profile: profile),
            if (profile.skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              PeerProfileChipsCard(icon: Icons.bar_chart_rounded, iconColor: AppColor.primaryBlue, title: 'Skills', items: profile.skills),
            ],
            if (profile.interests.isNotEmpty) ...[
              const SizedBox(height: 10),
              PeerProfileChipsCard(icon: Icons.favorite_rounded, iconColor: const Color(0xFFE91E63), title: 'Interests', items: profile.interests),
            ],
            const SizedBox(height: 10),
            PeerProfilePostsSection(
              profile: profile,
              posts: state.posts,
              isLoading: state.isPostsLoading,
              hasMore: state.hasMorePosts,
              isLoadingMore: state.isLoadingMorePosts,
              onLoadMore: () => bloc.add(const PeerProfilePostsLoadMoreRequested()),
              onLikeTap: (id) => bloc.add(PeerProfilePostLikeToggled(id)),
              onSaveTap: (id) => bloc.add(PeerProfilePostSaveToggled(id)),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset('assets/images/end_screen_image.png', width: double.infinity, fit: BoxFit.fitWidth),
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
    final isConnected = profile != null && (profile.isConnected || profile.connectionStatus.toLowerCase() == 'connected');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined, color: AppColor.lightTextPrimary),
              title: const Text('Share Profile', style: TextStyle(fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pop(ctx);
                AppSnackBar.showInfo(context, 'Profile link copied');
              },
            ),
            if (isConnected)
              ListTile(
                leading: const Icon(Icons.person_remove_outlined, color: AppColor.error),
                title: const Text('Remove Connection', style: TextStyle(color: AppColor.error, fontWeight: FontWeight.w400)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmRemoveConnection(context, bloc);
                },
              ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: AppColor.error),
              title: const Text('Report User', style: TextStyle(color: AppColor.error, fontWeight: FontWeight.w400)),
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

  void _confirmRemoveConnection(BuildContext context, PeerProfileBloc bloc) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Remove Connection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        content: Text('Are you sure you want to remove ${bloc.state.profile?.displayName ?? "this user"} from your connections?', style: const TextStyle(fontSize: 14, color: AppColor.lightTextSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel', style: TextStyle(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500))),
          TextButton(
            onPressed: () {
              Navigator.pop(dCtx);
              bloc.add(const PeerProfileRemoveConnectionRequested());
            },
            child: const Text('Remove', style: TextStyle(color: AppColor.error, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
