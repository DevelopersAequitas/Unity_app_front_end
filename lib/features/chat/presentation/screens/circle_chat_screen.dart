import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/circle_chat/circle_chat_bloc.dart';
import '../bloc/circle_chat/circle_chat_event.dart';
import '../bloc/circle_chat/circle_chat_state.dart';
import '../widgets/chat_action_bottom_sheet.dart';
import '../widgets/chat_bubble_item.dart';
import '../widgets/chat_date_header.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_shimmer_loading.dart';
import '../widgets/message_readers_bottom_sheet.dart';
import '../widgets/quoted_message_preview.dart';

class CircleChatScreen extends StatefulWidget {
  final String circleId;
  final String? circleName;

  const CircleChatScreen({
    super.key,
    required this.circleId,
    this.circleName,
  });

  @override
  State<CircleChatScreen> createState() => _CircleChatScreenState();
}

class _CircleChatScreenState extends State<CircleChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CircleChatBloc>().add(InitCircleChatEvent(
          circleId: widget.circleId,
          circleName: widget.circleName,
        ));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<CircleChatBloc>()
          .add(const LoadCircleMessagesEvent(isInitial: false));
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
        .read<CircleChatBloc>()
        .add(SendCircleMessageEvent(messageText: text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<CircleChatBloc, CircleChatState>(
      listener: (context, state) {
        if (state.selectedMessageId != null &&
            state.selectedMessageReaders.isNotEmpty) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => MessageReadersBottomSheet(
              readers: state.selectedMessageReaders,
              isLoading: state.isLoadingReaders,
            ),
          );
        }
      },
      builder: (context, state) {
        final circleTitle = state.circleName ?? 'Circle Chat';

        return Scaffold(
          appBar: AppBar(
            title: Column(
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
                  'Circle Group Discussion',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: isDark
                        ? AppColor.darkTextSecondary
                        : AppColor.lightTextSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.workspace_premium_rounded,
                    color: AppColor.primaryBlue),
                tooltip: 'Circle Leadership Chat',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.circleLeadershipChat,
                    arguments: {
                      'circle_id': widget.circleId,
                      'circle_name': widget.circleName,
                    },
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: state.status == CircleChatStatus.loading &&
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
                      .read<CircleChatBloc>()
                      .add(const SetQuotedReplyEvent(null)),
                ),
              ChatInputBar(
                controller: _inputController,
                onSend: _handleSend,
                onSendAttachment: (path, type) {
                  context.read<CircleChatBloc>().add(SendCircleMessageEvent(
                        messageText: '',
                        messageType: type,
                        filePath: path,
                      ));
                },
                isSending: state.isSending,
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
        onReply: () =>
            context.read<CircleChatBloc>().add(SetQuotedReplyEvent(msg)),
        onViewReads: () => context
            .read<CircleChatBloc>()
            .add(FetchMessageReadersEvent(msg.id)),
        onDeleteForMe: () {
          context.read<CircleChatBloc>().add(DeleteCircleMessageItemEvent(
                messageId: msg.id,
                forEveryone: false,
              ));
        },
        onDeleteForEveryone: msg.isMine
            ? () {
                context.read<CircleChatBloc>().add(DeleteCircleMessageItemEvent(
                      messageId: msg.id,
                      forEveryone: true,
                    ));
              }
            : null,
      ),
    );
  }
}
