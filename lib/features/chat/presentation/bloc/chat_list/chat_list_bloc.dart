import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/chat_conversation_entity.dart';
import '../../../domain/usecases/get_direct_chats_usecase.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetDirectChatsUseCase getDirectChatsUseCase;
  Timer? _refreshTimer;

  ChatListBloc({required this.getDirectChatsUseCase})
      : super(const ChatListState()) {
    on<LoadChatListEvent>(_onLoadChatList);
    on<RefreshChatListEvent>(_onRefreshChatList);
    on<SearchChatsEvent>(_onSearchChats);
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!isClosed) {
        add(const RefreshChatListEvent());
      }
    });
  }

  Future<void> _onLoadChatList(
    LoadChatListEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading));
    try {
      final chats = await getDirectChatsUseCase();
      final unread = chats.fold<int>(0, (sum, c) => sum + c.unreadCount);
      emit(state.copyWith(
        status: ChatListStatus.success,
        directChats: chats,
        filteredDirectChats: _filter(chats, state.searchQuery),
        totalUnreadCount: unread,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshChatList(
    RefreshChatListEvent event,
    Emitter<ChatListState> emit,
  ) async {
    try {
      final chats = await getDirectChatsUseCase();
      final unread = chats.fold<int>(0, (sum, c) => sum + c.unreadCount);
      emit(state.copyWith(
        status: ChatListStatus.success,
        directChats: chats,
        filteredDirectChats: _filter(chats, state.searchQuery),
        totalUnreadCount: unread,
      ));
    } catch (_) {}
  }

  void _onSearchChats(
    SearchChatsEvent event,
    Emitter<ChatListState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    emit(state.copyWith(
      searchQuery: query,
      filteredDirectChats: _filter(state.directChats, query),
    ));
  }

  List<ChatConversationEntity> _filter(
    List<ChatConversationEntity> chats,
    String query,
  ) {
    if (query.isEmpty) return chats;
    return chats.where((c) {
      final name = c.otherUser?.displayName.toLowerCase() ?? '';
      final snippet = c.lastMessage?.content.toLowerCase() ?? '';
      return name.contains(query) || snippet.contains(query);
    }).toList();
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
