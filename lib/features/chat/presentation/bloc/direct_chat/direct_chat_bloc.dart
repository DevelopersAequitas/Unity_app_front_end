import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_direct_message_usecase.dart';
import '../../../domain/usecases/get_direct_chat_detail_usecase.dart';
import '../../../domain/usecases/get_direct_messages_usecase.dart';
import '../../../domain/usecases/get_or_create_direct_chat_usecase.dart';
import '../../../domain/usecases/mark_direct_chat_read_usecase.dart';
import '../../../domain/usecases/send_direct_message_usecase.dart';
import '../../../domain/usecases/set_typing_status_usecase.dart';
import '../../../domain/entities/chat_message_entity.dart';
import 'direct_chat_event.dart';
import 'direct_chat_state.dart';

class DirectChatBloc extends Bloc<DirectChatEvent, DirectChatState> {
  final GetOrCreateDirectChatUseCase getOrCreateDirectChatUseCase;
  final GetDirectChatDetailUseCase getDirectChatDetailUseCase;
  final GetDirectMessagesUseCase getDirectMessagesUseCase;
  final SendDirectMessageUseCase sendDirectMessageUseCase;
  final MarkDirectChatReadUseCase markDirectChatReadUseCase;
  final SetTypingStatusUseCase setTypingStatusUseCase;
  final DeleteDirectMessageUseCase deleteDirectMessageUseCase;

  Timer? _syncTimer;

  DirectChatBloc({
    required this.getOrCreateDirectChatUseCase,
    required this.getDirectChatDetailUseCase,
    required this.getDirectMessagesUseCase,
    required this.sendDirectMessageUseCase,
    required this.markDirectChatReadUseCase,
    required this.setTypingStatusUseCase,
    required this.deleteDirectMessageUseCase,
  }) : super(const DirectChatState()) {
    on<InitDirectChatEvent>(_onInitDirectChat);
    on<LoadDirectMessagesEvent>(_onLoadDirectMessages);
    on<SendDirectMessageEvent>(_onSendDirectMessage);
    on<MarkDirectReadEvent>(_onMarkDirectRead);
    on<SetTypingIndicatorEvent>(_onSetTypingIndicator);
    on<DeleteDirectMessageItemEvent>(_onDeleteDirectMessage);
    on<SyncDirectMessagesEvent>(_onSyncDirectMessages);
    on<ResetDirectChatEvent>(_onResetDirectChat);
  }

  void _onResetDirectChat(
    ResetDirectChatEvent event,
    Emitter<DirectChatState> emit,
  ) {
    _syncTimer?.cancel();
    emit(const DirectChatState());
  }

  List<ChatMessageEntity> _sortMessages(List<ChatMessageEntity> messages) {
    final unique = <String, ChatMessageEntity>{};
    for (final m in messages) {
      final key = m.id.isNotEmpty
          ? m.id
          : 'temp_${m.createdAt.microsecondsSinceEpoch}_${m.content}';
      unique[key] = m;
    }
    final list = unique.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> _onInitDirectChat(
    InitDirectChatEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    _syncTimer?.cancel();
    emit(DirectChatState(
      status: DirectChatStatus.loading,
      chatId: event.chatId,
      peerUserId: event.peerUserId,
      peerName: event.peerName,
      peerAvatar: event.peerAvatar,
      messages: const [],
      conversation: null,
      currentPage: 1,
      hasReachedEnd: false,
      isSending: false,
      isLoadingMore: false,
      isPeerTyping: false,
      errorMessage: null,
    ));

    try {
      String resolvedChatId = event.chatId ?? '';
      if (resolvedChatId.isEmpty && event.peerUserId != null && event.peerUserId!.isNotEmpty) {
        final conv = await getOrCreateDirectChatUseCase(event.peerUserId!);
        resolvedChatId = conv.id;
        emit(state.copyWith(
          chatId: resolvedChatId,
          conversation: conv,
          peerName: conv.otherUser?.displayName ?? event.peerName,
          peerAvatar: conv.otherUser?.profilePhotoUrl ?? event.peerAvatar,
        ));
      }

      if (resolvedChatId.isNotEmpty) {
        final messages = await getDirectMessagesUseCase(resolvedChatId, page: 1);
        final sorted = _sortMessages(messages);
        emit(state.copyWith(
          status: DirectChatStatus.success,
          chatId: resolvedChatId,
          messages: sorted,
          currentPage: 1,
          hasReachedEnd: messages.length < 50,
        ));
        markDirectChatReadUseCase(resolvedChatId);
        _startSyncTimer();
      } else {
        emit(state.copyWith(
          status: DirectChatStatus.error,
          errorMessage: 'Unable to open chat conversation.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: DirectChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isClosed) {
        add(const SyncDirectMessagesEvent());
      }
    });
  }

  Future<void> _onSyncDirectMessages(
    SyncDirectMessagesEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    final chatId = state.chatId;
    if (chatId == null || chatId.isEmpty || state.isSending) return;

    try {
      final latestMessages = await getDirectMessagesUseCase(chatId, page: 1);

      bool isPeerTyping = state.isPeerTyping;
      try {
        final detail = await getDirectChatDetailUseCase(chatId);
        final typingNow = detail.otherUser?.isTyping == true;
        isPeerTyping = typingNow;
      } catch (_) {}

      if (latestMessages.isEmpty) {
        if (isPeerTyping != state.isPeerTyping) {
          emit(state.copyWith(isPeerTyping: isPeerTyping));
        }
        return;
      }

      final existingIds = state.messages
          .map((m) => m.id)
          .where((id) => id.isNotEmpty)
          .toSet();
      final newItems =
          latestMessages.where((m) => !existingIds.contains(m.id)).toList();

      final latestMap = {
        for (var m in latestMessages)
          if (m.id.isNotEmpty) m.id: m
      };
      bool hasReadStatusChange = false;
      final updatedExisting = state.messages.map((m) {
        if (latestMap.containsKey(m.id)) {
          final refreshed = latestMap[m.id]!;
          if (refreshed.isRead != m.isRead ||
              refreshed.readCount != m.readCount ||
              refreshed.isReadByMe != m.isReadByMe) {
            hasReadStatusChange = true;
            return m.copyWith(
              isRead: refreshed.isRead,
              readCount: refreshed.readCount,
              isReadByMe: refreshed.isReadByMe,
            );
          }
        }
        return m;
      }).toList();

      if (newItems.isNotEmpty ||
          hasReadStatusChange ||
          isPeerTyping != state.isPeerTyping) {
        final merged = _sortMessages([...newItems, ...updatedExisting]);
        emit(state.copyWith(
          messages: merged,
          isPeerTyping: isPeerTyping,
        ));
        if (newItems.any((m) => !m.isMine)) {
          markDirectChatReadUseCase(chatId);
        }
      }
    } catch (_) {}
  }

  Future<void> _onLoadDirectMessages(
    LoadDirectMessagesEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    final chatId = state.chatId;
    if (chatId == null || chatId.isEmpty || state.isLoadingMore || state.hasReachedEnd) return;

    final nextPage = event.isInitial ? 1 : state.currentPage + 1;
    if (!event.isInitial) emit(state.copyWith(isLoadingMore: true));

    try {
      final newMessages =
          await getDirectMessagesUseCase(chatId, page: nextPage);
      final all = event.isInitial
          ? _sortMessages(newMessages)
          : _sortMessages([...state.messages, ...newMessages]);
      emit(state.copyWith(
        messages: all,
        currentPage: nextPage,
        hasReachedEnd: newMessages.length < 50,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSendDirectMessage(
    SendDirectMessageEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    String? chatId = state.chatId;
    if (chatId == null || chatId.isEmpty) {
      if (state.peerUserId != null && state.peerUserId!.isNotEmpty) {
        try {
          final conv = await getOrCreateDirectChatUseCase(state.peerUserId!);
          chatId = conv.id;
          emit(state.copyWith(
            chatId: chatId,
            conversation: conv,
            peerName: conv.otherUser?.displayName ?? state.peerName,
            peerAvatar: conv.otherUser?.profilePhotoUrl ?? state.peerAvatar,
          ));
        } catch (_) {}
      }
    }

    if (chatId == null || chatId.isEmpty || state.isSending) return;

    emit(state.copyWith(isSending: true));
    try {
      final sent = await sendDirectMessageUseCase(
        chatId,
        content: event.content,
        filePath: event.filePath,
        fileType: event.fileType,
      );
      final updatedList = _sortMessages([sent, ...state.messages]);
      emit(state.copyWith(
        isSending: false,
        messages: updatedList,
      ));
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onMarkDirectRead(
    MarkDirectReadEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    final chatId = state.chatId;
    if (chatId != null) await markDirectChatReadUseCase(chatId);
  }

  Future<void> _onSetTypingIndicator(
    SetTypingIndicatorEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    final chatId = state.chatId;
    if (chatId != null) {
      setTypingStatusUseCase(chatId, isTyping: event.isTyping);
    }
  }

  Future<void> _onDeleteDirectMessage(
    DeleteDirectMessageItemEvent event,
    Emitter<DirectChatState> emit,
  ) async {
    try {
      final success = await deleteDirectMessageUseCase(
        event.messageId,
        forEveryone: event.forEveryone,
      );
      if (success) {
        final updated =
            state.messages.where((m) => m.id != event.messageId).toList();
        emit(state.copyWith(messages: updated));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _syncTimer?.cancel();
    return super.close();
  }
}
