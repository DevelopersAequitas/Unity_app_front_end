import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_leadership_message_usecase.dart';
import '../../../domain/usecases/get_leadership_messages_usecase.dart';
import '../../../domain/usecases/get_leadership_roster_usecase.dart';
import '../../../domain/usecases/mark_leadership_messages_read_usecase.dart';
import '../../../domain/usecases/send_leadership_message_usecase.dart';
import 'leadership_chat_event.dart';
import 'leadership_chat_state.dart';

class LeadershipChatBloc
    extends Bloc<LeadershipChatEvent, LeadershipChatState> {
  final GetLeadershipRosterUseCase getLeadershipRosterUseCase;
  final GetLeadershipMessagesUseCase getLeadershipMessagesUseCase;
  final SendLeadershipMessageUseCase sendLeadershipMessageUseCase;
  final MarkLeadershipMessagesReadUseCase markLeadershipMessagesReadUseCase;
  final DeleteLeadershipMessageUseCase deleteLeadershipMessageUseCase;

  Timer? _syncTimer;

  LeadershipChatBloc({
    required this.getLeadershipRosterUseCase,
    required this.getLeadershipMessagesUseCase,
    required this.sendLeadershipMessageUseCase,
    required this.markLeadershipMessagesReadUseCase,
    required this.deleteLeadershipMessageUseCase,
  }) : super(const LeadershipChatState()) {
    on<InitLeadershipChatEvent>(_onInitLeadershipChat);
    on<LoadLeadershipMessagesEvent>(_onLoadLeadershipMessages);
    on<SendLeadershipMessageEvent>(_onSendLeadershipMessage);
    on<SetLeadershipQuotedReplyEvent>(_onSetLeadershipQuotedReply);
    on<DeleteLeadershipMessageItemEvent>(_onDeleteLeadershipMessage);
    on<SyncLeadershipMessagesEvent>(_onSyncLeadershipMessages);
  }

  Future<void> _onInitLeadershipChat(
    InitLeadershipChatEvent event,
    Emitter<LeadershipChatState> emit,
  ) async {
    emit(state.copyWith(
      status: LeadershipChatStatus.loading,
      circleId: event.circleId,
      circleName: event.circleName,
    ));
    try {
      final roster = await getLeadershipRosterUseCase(event.circleId);
      final messages = await getLeadershipMessagesUseCase(event.circleId,
          page: 1, perPage: 20);

      emit(state.copyWith(
        status: LeadershipChatStatus.success,
        roster: roster,
        messages: messages,
        currentPage: 1,
        hasReachedEnd: messages.length < 20,
      ));

      final unreadIds =
          messages.where((m) => !m.isRead).map((m) => m.id).toList();
      if (unreadIds.isNotEmpty) {
        markLeadershipMessagesReadUseCase(event.circleId, unreadIds);
      }
      _startSyncTimer();
    } catch (e) {
      emit(state.copyWith(
        status: LeadershipChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isClosed) {
        add(const SyncLeadershipMessagesEvent());
      }
    });
  }

  Future<void> _onSyncLeadershipMessages(
    SyncLeadershipMessagesEvent event,
    Emitter<LeadershipChatState> emit,
  ) async {
    if (state.circleId.isEmpty || state.isSending) return;

    try {
      final latestMessages = await getLeadershipMessagesUseCase(state.circleId,
          page: 1, perPage: 20);
      if (latestMessages.isEmpty) return;

      final existingIds = state.messages.map((m) => m.id).toSet();
      final newItems =
          latestMessages.where((m) => !existingIds.contains(m.id)).toList();

      final latestMap = {for (var m in latestMessages) m.id: m};
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

      if (newItems.isNotEmpty || hasReadStatusChange) {
        final merged = [...newItems, ...updatedExisting];
        emit(state.copyWith(messages: merged));
        final unreadIds =
            newItems.where((m) => !m.isRead).map((m) => m.id).toList();
        if (unreadIds.isNotEmpty) {
          markLeadershipMessagesReadUseCase(state.circleId, unreadIds);
        }
      }
    } catch (_) {}
  }

  Future<void> _onLoadLeadershipMessages(
    LoadLeadershipMessagesEvent event,
    Emitter<LeadershipChatState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedEnd) return;
    final nextPage = event.isInitial ? 1 : state.currentPage + 1;
    if (!event.isInitial) emit(state.copyWith(isLoadingMore: true));
    try {
      final newMsgs = await getLeadershipMessagesUseCase(
        state.circleId,
        page: nextPage,
        perPage: 20,
      );
      final all = event.isInitial ? newMsgs : [...state.messages, ...newMsgs];
      emit(state.copyWith(
        messages: all,
        currentPage: nextPage,
        hasReachedEnd: newMsgs.length < 20,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSendLeadershipMessage(
    SendLeadershipMessageEvent event,
    Emitter<LeadershipChatState> emit,
  ) async {
    if (state.isSending) return;
    emit(state.copyWith(isSending: true));
    try {
      final msg = await sendLeadershipMessageUseCase(
        state.circleId,
        messageText: event.messageText,
        messageType: event.messageType,
        replyToMessageId: event.replyToMessageId ?? state.quotedReply?.id,
        filePath: event.filePath,
      );
      emit(state.copyWith(
        isSending: false,
        clearQuotedReply: true,
        messages: [msg, ...state.messages],
      ));
    } catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: e.toString()));
    }
  }

  void _onSetLeadershipQuotedReply(
    SetLeadershipQuotedReplyEvent event,
    Emitter<LeadershipChatState> emit,
  ) {
    emit(state.copyWith(
      quotedReply: event.quotedMessage,
      clearQuotedReply: event.quotedMessage == null,
    ));
  }

  Future<void> _onDeleteLeadershipMessage(
    DeleteLeadershipMessageItemEvent event,
    Emitter<LeadershipChatState> emit,
  ) async {
    try {
      final ok = await deleteLeadershipMessageUseCase(
        state.circleId,
        event.messageId,
        forEveryone: event.forEveryone,
      );
      if (ok) {
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
