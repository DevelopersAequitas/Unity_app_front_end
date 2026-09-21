import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatListEvent extends ChatListEvent {
  const LoadChatListEvent();
}

class RefreshChatListEvent extends ChatListEvent {
  const RefreshChatListEvent();
}

class SearchChatsEvent extends ChatListEvent {
  final String query;
  const SearchChatsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
