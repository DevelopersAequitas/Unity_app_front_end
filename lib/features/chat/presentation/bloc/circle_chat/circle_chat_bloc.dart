import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_circle_message_usecase.dart';
import '../../../domain/usecases/get_circle_message_reads_usecase.dart';
import '../../../domain/usecases/get_circle_messages_usecase.dart';
import '../../../domain/usecases/mark_circle_messages_read_usecase.dart';
import '../../../domain/usecases/send_circle_message_usecase.dart';
import 'circle_chat_event.dart';
import 'circle_chat_state.dart';

class CircleChatBloc extends Bloc<CircleChatEvent, CircleChatState> {
  final GetCircleMessagesUseCase getCircleMessagesUseCase;
  final SendCircleMessageUseCase sendCircleMessageUseCase;
  final MarkCircleMessagesReadUseCase markCircleMessagesReadUseCase;
  final GetCircleMessageReadsUseCase getCircleMessageReadsUseCase;
  final DeleteCircleMessageUseCase deleteCircleMessageUseCase;

  Timer? _syncTimer;

  CircleChatBloc({
    required this.getCircleMessagesUseCase,
    required this.sendCircleMessageUseCase,
    required this.markCircleMessagesReadUseCase,
    required this.getCircleMessageReadsUseCase,
    required this.deleteCircleMessageUseCase,
  }) : super(const CircleChatState()) {
    on<InitCircleChatEvent>(_onInitCircleChat);
    on<LoadCircleMessagesEvent>(_onLoadCircleMessages);
    on<SendCircleMessageEvent>(_onSendCircleMessage);
    on<SetQuotedReplyEvent>(_onSetQuotedReply);
    on<FetchMessageReadersEvent>(_onFetchMessageReaders);
    on<DeleteCircleMessageItemEvent>(_onDeleteCircleMessage);
    on<SyncCircleMessagesEvent>(_onSyncCircleMessages);
  }

  Future<void> _onInitCircleChat(
    InitCircleChatEvent event,
    Emitter<CircleChatState> emit,
  ) async {
    emit(state.copyWith(
      status: CircleChatStatus.loading,
      circleId: event.circleId,
      circleName: event.circleName,
    ));
    try {
      final messages =
          await getCircleMessagesUseCase(event.circleId, page: 1, perPage: 20);
      emit(state.copyWith(
        status: CircleChatStatus.success,
        messages: messages,
        currentPage: 1,
        hasReachedEnd: messages.length < 20,
      ));
      final unreadIds = messages.where((m) => !m.isReadByMe).map((m) => m.id).toList();
      if (unreadIds.isNotEmpty) {
        markCircleMessagesReadUseCase(event.circleId, unreadIds);
      }
      _startSyncTimer();
    } catch (e) {
      emit(state.copyWith(
        status: CircleChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isClosed) {
        add(const SyncCircleMessagesEvent());
      }
    });
  }

  Future<void> _onSyncCircleMessages(
    SyncCircleMessagesEvent event,
    Emitter<CircleChatState> emit,
  ) async {
    if (state.circleId.isEmpty || state.isSending) return;

    try {
      final latestMessages =
          await getCircleMessagesUseCase(state.circleId, page: 1, perPage: 20);
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
            newItems.where((m) => !m.isReadByMe).map((m) => m.id).toList();
        if (unreadIds.isNotEmpty) {
          markCircleMessagesReadUseCase(state.circleId, unreadIds);
        }
      }
    } catch (_) {}
  }

  Future<void> _onLoadCircleMessages(
    LoadCircleMessagesEvent event,
    Emitter<CircleChatState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedEnd) return;
    final nextPage = event.isInitial ? 1 : state.currentPage + 1;
    if (!event.isInitial) emit(state.copyWith(isLoadingMore: true));
    try {
      final newMsgs = await getCircleMessagesUseCase(
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

  Future<void> _onSendCircleMessage(
    SendCircleMessageEvent event,
    Emitter<CircleChatState> emit,
  ) async {
    if (state.isSending) return;
    emit(state.copyWith(isSending: true));
    try {
      final msg = await sendCircleMessageUseCase(
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

  void _onSetQuotedReply(
    SetQuotedReplyEvent event,
    Emitter<CircleChatState> emit,
  ) {
    emit(state.copyWith(
      quotedReply: event.quotedMessage,
      clearQuotedReply: event.quotedMessage == null,
    ));
  }

  Future<void> _onFetchMessageReaders(
    FetchMessageReadersEvent event,
    Emitter<CircleChatState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingReaders: true,
      selectedMessageId: event.messageId,
    ));
    try {
      final readers = await getCircleMessageReadsUseCase(
        state.circleId,
        event.messageId,
      );
      emit(state.copyWith(
        isLoadingReaders: false,
        selectedMessageReaders: readers,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingReaders: false));
    }
  }

  Future<void> _onDeleteCircleMessage(
    DeleteCircleMessageItemEvent event,
    Emitter<CircleChatState> emit,
  ) async {
    try {
      final ok = await deleteCircleMessageUseCase(
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
