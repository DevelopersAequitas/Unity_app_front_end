import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/direct_chat/direct_chat_bloc.dart';
import '../bloc/direct_chat/direct_chat_event.dart';
import '../bloc/direct_chat/direct_chat_state.dart';
import '../widgets/chat_action_bottom_sheet.dart';
import '../widgets/chat_bubble_item.dart';
import '../widgets/chat_date_header.dart';
import '../widgets/chat_empty_view.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_shimmer_loading.dart';

class DirectChatScreen extends StatefulWidget {
  final String? chatId;
  final String? peerUserId;
  final String? peerName;
  final String? peerAvatar;
  final String? initialMessage;

  const DirectChatScreen({
    super.key,
    this.chatId,
    this.peerUserId,
    this.peerName,
    this.peerAvatar,
    this.initialMessage,
  });

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  late final DirectChatBloc _directChatBloc;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingDebounce;
  bool _isCurrentlyTyping = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      _inputController.text = widget.initialMessage!.trim();
    }
    _directChatBloc = context.read<DirectChatBloc>();
    _directChatBloc.add(InitDirectChatEvent(
          chatId: widget.chatId,
          peerUserId: widget.peerUserId,
          peerName: widget.peerName,
          peerAvatar: widget.peerAvatar,
        ));
    _scrollController.addListener(_onScroll);
    _inputController.addListener(_onInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !PaywallGateHelper.isPro(context)) {
        Navigator.pushReplacementNamed(context, AppRoutes.membershipPaywall);
      }
    });
  }

  void _onInputChanged() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      if (!_isCurrentlyTyping) {
        _isCurrentlyTyping = true;
        _directChatBloc.add(const SetTypingIndicatorEvent(isTyping: true));
      }
      _typingDebounce?.cancel();
      _typingDebounce = Timer(const Duration(milliseconds: 1500), () {
        if (_isCurrentlyTyping && mounted) {
          _isCurrentlyTyping = false;
          _directChatBloc.add(const SetTypingIndicatorEvent(isTyping: false));
        }
      });
    } else {
      if (_isCurrentlyTyping) {
        _isCurrentlyTyping = false;
        _typingDebounce?.cancel();
        _directChatBloc.add(const SetTypingIndicatorEvent(isTyping: false));
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _directChatBloc.add(const LoadDirectMessagesEvent(isInitial: false));
    }
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    if (_isCurrentlyTyping) {
      _directChatBloc.add(const SetTypingIndicatorEvent(isTyping: false));
    }
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _scrollController.dispose();
    _directChatBloc.add(const ResetDirectChatEvent());
    super.dispose();
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _typingDebounce?.cancel();
    if (_isCurrentlyTyping) {
      _isCurrentlyTyping = false;
      context
          .read<DirectChatBloc>()
          .add(const SetTypingIndicatorEvent(isTyping: false));
    }
    _inputController.clear();
    context
        .read<DirectChatBloc>()
        .add(SendDirectMessageEvent(content: text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DirectChatBloc, DirectChatState>(
      builder: (context, state) {
        final otherUser = state.conversation?.otherUser;
        final titleName = state.peerName ??
            otherUser?.displayName ??
            'Direct Chat';
        final photoUrl = state.peerAvatar ?? otherUser?.profilePhotoUrl;
        final peerId = state.peerUserId ?? otherUser?.id;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: InkWell(
              onTap: (peerId != null && peerId.isNotEmpty)
                  ? () => Navigator.pushNamed(
                        context,
                        AppRoutes.peerProfile,
                        arguments: peerId,
                      )
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Row(
                  children: [
                    AppAvatar(
                      imageUrl: photoUrl,
                      name: titleName,
                      size: 36,
                      showOnlineBadge: true,
                      isOnline: otherUser?.isOnline ?? true,
                      isPro: otherUser?.isPro ?? false,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  titleName,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColor.darkTextPrimary
                                        : AppColor.lightTextPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (otherUser?.isVerified == true) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: AppColor.primaryBlue,
                                ),
                              ],
                              if (otherUser?.isPro == true) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColor.brandGradient,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'PRO',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            state.isPeerTyping
                                ? 'Typing...'
                                : (otherUser?.category?.isNotEmpty == true
                                    ? otherUser!.category!
                                    : (otherUser?.isOnline == true
                                        ? 'Active now'
                                        : 'Peer Member')),
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: state.isPeerTyping
                                  ? AppColor.primaryBlue
                                  : (isDark
                                      ? AppColor.darkTextSecondary
                                      : AppColor.lightTextSecondary),
                              fontWeight: state.isPeerTyping
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: state.status == DirectChatStatus.loading &&
                        state.messages.isEmpty
                    ? const ChatShimmerLoading()
                    : state.messages.isEmpty
                        ? ChatEmptyView(
                            icon: Icons.waving_hand_rounded,
                            title: 'Say Hello to $titleName',
                            subtitle:
                                'Send a message or voice note to introduce yourself and start collaborating.',
                          )
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
                                    onLongPress: () => _showMessageActions(msg),
                                  ),
                                ],
                              );
                            },
                          ),
              ),
              ChatInputBar(
                controller: _inputController,
                onSend: _handleSend,
                onSendAttachment: (path, type) {
                  context.read<DirectChatBloc>().add(SendDirectMessageEvent(
                        content: '',
                        filePath: path,
                        fileType: type,
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
        onReply: () {
          _inputController.text = '@${msg.sender?.displayName ?? 'Peer'} ';
        },
        onDeleteForMe: () {
          context.read<DirectChatBloc>().add(DeleteDirectMessageItemEvent(
                messageId: msg.id,
                forEveryone: false,
              ));
        },
        onDeleteForEveryone: msg.isMine
            ? () {
                context.read<DirectChatBloc>().add(DeleteDirectMessageItemEvent(
                      messageId: msg.id,
                      forEveryone: true,
                    ));
              }
            : null,
      ),
    );
  }
}
