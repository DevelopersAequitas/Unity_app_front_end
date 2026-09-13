import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/post_comment_entity.dart';
import '../../domain/usecases/add_post_comment_usecase.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';

String _formatTimeAgo(String raw) {
  try {
    final dt = DateTime.parse(raw).toLocal();
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  } catch (_) {
    return raw;
  }
}

class PostCommentsBottomSheet extends StatefulWidget {
  final String postId;
  final int totalComments;
  final VoidCallback? onCommentAdded;

  const PostCommentsBottomSheet({
    super.key,
    required this.postId,
    required this.totalComments,
    this.onCommentAdded,
  });

  static Future<void> show(
    BuildContext context, {
    required String postId,
    int totalComments = 0,
    VoidCallback? onCommentAdded,
  }) {
    final getCommentsUseCase = context.read<GetPostCommentsUseCase>();
    final addCommentUseCase = context.read<AddPostCommentUseCase>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GetPostCommentsUseCase>.value(value: getCommentsUseCase),
          RepositoryProvider<AddPostCommentUseCase>.value(value: addCommentUseCase),
        ],
        child: PostCommentsBottomSheet(
          postId: postId,
          totalComments: totalComments,
          onCommentAdded: onCommentAdded,
        ),
      ),
    );
  }

  @override
  State<PostCommentsBottomSheet> createState() => _PostCommentsBottomSheetState();
}

class _PostCommentsBottomSheetState extends State<PostCommentsBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  List<PostCommentEntity> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final comments = await context.read<GetPostCommentsUseCase>().call(widget.postId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load comments';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitComment() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    _textController.clear();
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimisticComment = PostCommentEntity(
      id: tempId,
      userId: '',
      displayName: 'You',
      content: text,
      createdAt: DateTime.now().toIso8601String(),
    );

    setState(() {
      _comments = [optimisticComment, ..._comments];
      _isSending = true;
    });

    widget.onCommentAdded?.call();

    try {
      final realComment = await context.read<AddPostCommentUseCase>().call(widget.postId, text);
      if (mounted) {
        setState(() {
          _comments = _comments.map((c) => c.id == tempId ? realComment : c).toList();
          _isSending = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _comments = _comments.where((c) => c.id != tempId).toList();
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to post comment. Please try again.')),
        );
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
    final count = _comments.isNotEmpty ? _comments.length : widget.totalComments;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
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
                const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColor.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Comments ($count)',
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
          const Divider(height: 1, color: AppColor.lightBorder),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, index) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColor.lightBorder,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 110,
                    decoration: BoxDecoration(
                      color: AppColor.lightBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.lightBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
              onPressed: _fetchComments,
              child: const Text('Retry', style: TextStyle(fontSize: 12, color: AppColor.primaryBlue, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
    }

    if (_comments.isEmpty) {
      return const Center(
        child: Text('No comments yet. Be the first to comment!', style: TextStyle(fontSize: 12.5, color: AppColor.lightTextSecondary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _comments.length,
      separatorBuilder: (_, _) => const Divider(height: 16, color: AppColor.lightBorder),
      itemBuilder: (context, index) {
        final comment = _comments[index];
        final targetId = comment.userId.isNotEmpty ? comment.userId : comment.id;
        final subInfo = [
          if (comment.designation != null && comment.designation!.trim().isNotEmpty) comment.designation!.trim(),
          if (comment.companyName != null && comment.companyName!.trim().isNotEmpty) comment.companyName!.trim(),
        ].join(' • ');

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _navigateToPeer(targetId),
              borderRadius: BorderRadius.circular(18),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
                backgroundImage: comment.profilePhotoUrl != null && comment.profilePhotoUrl!.isNotEmpty
                    ? NetworkImage(comment.profilePhotoUrl!)
                    : null,
                child: comment.profilePhotoUrl == null || comment.profilePhotoUrl!.isEmpty
                    ? Text(
                        comment.displayName.isNotEmpty ? comment.displayName[0].toUpperCase() : 'P',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColor.primaryBlue),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _navigateToPeer(targetId),
                        child: Text(
                          comment.displayName,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTimeAgo(comment.createdAt),
                        style: const TextStyle(fontSize: 10, color: AppColor.lightTextTertiary),
                      ),
                    ],
                  ),
                  if (subInfo.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      subInfo,
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w400, color: AppColor.lightTextSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if ((comment.category != null && comment.category!.trim().isNotEmpty) ||
                      (comment.city != null && comment.city!.trim().isNotEmpty)) ...[
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        if (comment.category != null && comment.category!.trim().isNotEmpty)
                          Flexible(
                            child: AppGradientText(
                              comment.category!.trim(),
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (comment.category != null &&
                            comment.category!.trim().isNotEmpty &&
                            comment.city != null &&
                            comment.city!.trim().isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text('•', style: TextStyle(fontSize: 9.5, color: AppColor.lightTextTertiary)),
                          ),
                        if (comment.city != null && comment.city!.trim().isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 9.5, color: AppColor.lightTextTertiary),
                              const SizedBox(width: 2),
                              Text(
                                comment.city!.trim(),
                                style: const TextStyle(fontSize: 9.5, color: AppColor.lightTextSecondary),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: const TextStyle(fontSize: 12, height: 1.4, fontWeight: FontWeight.w400, color: AppColor.lightTextPrimary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.lightBorder),
                ),
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(fontSize: 12.5, color: AppColor.lightTextPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(fontSize: 12, color: AppColor.lightTextTertiary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onSubmitted: (_) => _submitComment(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _submitComment,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
