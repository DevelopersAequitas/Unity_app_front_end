import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/post_like_entity.dart';
import '../../domain/usecases/get_post_likes_usecase.dart';

class PostLikesBottomSheet extends StatefulWidget {
  final String postId;
  final int totalLikes;

  const PostLikesBottomSheet({
    super.key,
    required this.postId,
    required this.totalLikes,
  });

  static Future<void> show(
    BuildContext context, {
    required String postId,
    int totalLikes = 0,
  }) {
    final useCase = context.read<GetPostLikesUseCase>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RepositoryProvider<GetPostLikesUseCase>.value(
        value: useCase,
        child: PostLikesBottomSheet(
          postId: postId,
          totalLikes: totalLikes,
        ),
      ),
    );
  }

  @override
  State<PostLikesBottomSheet> createState() => _PostLikesBottomSheetState();
}

class _PostLikesBottomSheetState extends State<PostLikesBottomSheet> {
  List<PostLikeEntity> _likes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLikes();
  }

  Future<void> _fetchLikes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final likes = await context.read<GetPostLikesUseCase>().call(widget.postId);
      if (mounted) {
        setState(() {
          _likes = likes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load likes';
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToPeer(String peerId) {
    if (peerId.isEmpty) return;
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: peerId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = _likes.isNotEmpty ? _likes.length : widget.totalLikes;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, size: 18, color: AppColor.primaryPink),
                const SizedBox(width: 8),
                Text(
                  'Likes ($count)',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColor.lightTextSecondary),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColor.lightBorder),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: const TextStyle(fontSize: 12, color: AppColor.lightTextSecondary)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _fetchLikes,
              child: const Text('Retry', style: TextStyle(fontSize: 12, color: AppColor.primaryBlue, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    }

    if (_likes.isEmpty) {
      return const Center(
        child: Text('No likes yet', style: TextStyle(fontSize: 12.5, color: AppColor.lightTextSecondary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _likes.length,
      separatorBuilder: (_, _) => const Divider(height: 16, color: AppColor.lightBorder),
      itemBuilder: (context, index) {
        final peer = _likes[index];
        final targetId = peer.userId.isNotEmpty ? peer.userId : peer.id;
        final subInfo = [
          if (peer.designation != null && peer.designation!.trim().isNotEmpty) peer.designation!.trim(),
          if (peer.companyName != null && peer.companyName!.trim().isNotEmpty) peer.companyName!.trim(),
        ].join(' • ');

        return InkWell(
          onTap: () => _navigateToPeer(targetId),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
                  backgroundImage: peer.profilePhotoUrl != null && peer.profilePhotoUrl!.isNotEmpty
                      ? NetworkImage(peer.profilePhotoUrl!)
                      : null,
                  child: peer.profilePhotoUrl == null || peer.profilePhotoUrl!.isEmpty
                      ? Text(
                          peer.displayName.isNotEmpty ? peer.displayName[0].toUpperCase() : 'P',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColor.primaryBlue),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        peer.displayName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subInfo.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          subInfo,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColor.lightTextSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if ((peer.category != null && peer.category!.trim().isNotEmpty) ||
                          (peer.city != null && peer.city!.trim().isNotEmpty)) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (peer.category != null && peer.category!.trim().isNotEmpty)
                              Flexible(
                                child: AppGradientText(
                                  peer.category!.trim(),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            if (peer.category != null &&
                                peer.category!.trim().isNotEmpty &&
                                peer.city != null &&
                                peer.city!.trim().isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text('•', style: TextStyle(fontSize: 10, color: AppColor.lightTextTertiary)),
                              ),
                            if (peer.city != null && peer.city!.trim().isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 10, color: AppColor.lightTextTertiary),
                                  const SizedBox(width: 2),
                                  Text(
                                    peer.city!.trim(),
                                    style: const TextStyle(fontSize: 10, color: AppColor.lightTextSecondary),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
