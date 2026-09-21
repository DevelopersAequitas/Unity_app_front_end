import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/leadership_chat/leadership_chat_bloc.dart';
import '../bloc/leadership_chat/leadership_chat_event.dart';
import '../bloc/leadership_chat/leadership_chat_state.dart';
import '../widgets/chat_action_bottom_sheet.dart';
import '../widgets/chat_bubble_item.dart';
import '../widgets/chat_date_header.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_shimmer_loading.dart';
import '../widgets/leadership_roster_sheet.dart';
import '../widgets/quoted_message_preview.dart';

class CircleLeadershipChatScreen extends StatefulWidget {
  final String circleId;
  final String? circleName;

  const CircleLeadershipChatScreen({
    super.key,
    required this.circleId,
    this.circleName,
  });

  @override
  State<CircleLeadershipChatScreen> createState() =>
      _CircleLeadershipChatScreenState();
}

class _CircleLeadershipChatScreenState
    extends State<CircleLeadershipChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<LeadershipChatBloc>().add(InitLeadershipChatEvent(
          circleId: widget.circleId,
          circleName: widget.circleName,
        ));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<LeadershipChatBloc>()
          .add(const LoadLeadershipMessagesEvent(isInitial: false));
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    context
        .read<LeadershipChatBloc>()
        .add(SendLeadershipMessageEvent(messageText: text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LeadershipChatBloc, LeadershipChatState>(
      builder: (context, state) {
        final circleTitle = state.circleName ??
            state.roster?.circleName ??
            'Circle Leadership';

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColor.primaryBlue.withValues(alpha: 0.15)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColor.primaryBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 18,
                    color: AppColor.primaryBlue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        circleTitle,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColor.darkTextPrimary
                              : AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Leadership Council • ${state.roster?.totalMembers ?? 5} Leaders',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColor.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (state.roster != null)
                IconButton(
                  icon: const Icon(
                    Icons.shield_outlined,
                    color: AppColor.primaryBlue,
                  ),
                  tooltip: 'Leadership Roster',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) =>
                          LeadershipRosterSheet(roster: state.roster!),
                    );
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkSurfaceSubtle
                      : const Color(0xFFF1F5F9),
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 13,
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.lightTextSecondary,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Confidential Channel • Restricted to Chapter Officers',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.status == LeadershipChatStatus.loading &&
                        state.messages.isEmpty
                    ? const ChatShimmerLoading()
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg = state.messages[index];
                          final showDate = index == state.messages.length - 1 ||
                              !_isSameDay(msg.createdAt,
                                  state.messages[index + 1].createdAt);

                          return Column(
                            children: [
                              if (showDate) ChatDateHeader(date: msg.createdAt),
                              ChatBubbleItem(
                                message: msg,
                                showSenderName: true,
                                isLeadership: true,
                                onLongPress: () => _showMessageActions(msg),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (state.quotedReply != null)
                QuotedMessagePreview(
                  quotedMessage: state.quotedReply!,
                  onClose: () => context
                      .read<LeadershipChatBloc>()
                      .add(const SetLeadershipQuotedReplyEvent(null)),
                ),
              ChatInputBar(
                controller: _inputController,
                onSend: _handleSend,
                onSendAttachment: (path, type) {
                  context.read<LeadershipChatBloc>().add(
                        SendLeadershipMessageEvent(
                          messageText: '',
                          messageType: type,
                          filePath: path,
                        ),
                      );
                },
                isSending: state.isSending,
                hintText: 'Message leadership team...',
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _showMessageActions(ChatMessageEntity msg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChatActionBottomSheet(
        message: msg,
        onReply: () => context
            .read<LeadershipChatBloc>()
            .add(SetLeadershipQuotedReplyEvent(msg)),
        onDeleteForMe: () {
          context.read<LeadershipChatBloc>().add(
                DeleteLeadershipMessageItemEvent(
                  messageId: msg.id,
                  forEveryone: false,
                ),
              );
        },
        onDeleteForEveryone: msg.isMine
            ? () {
                context.read<LeadershipChatBloc>().add(
                      DeleteLeadershipMessageItemEvent(
                        messageId: msg.id,
                        forEveryone: true,
                      ),
                    );
              }
            : null,
      ),
    );
  }
}
