import 'package:equatable/equatable.dart';
import '../../domain/entities/peer_entity.dart';

enum ConnectionsStatus { initial, loading, success, failure }

class ConnectionsState extends Equatable {
  final ConnectionsStatus status;
  final List<PeerEntity> connections;
  final bool hasMore;
  final bool isLoadingMore;
  final int page;
  final String searchQuery;
  final String? errorMessage;

  const ConnectionsState({
    this.status = ConnectionsStatus.initial,
    this.connections = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.page = 1,
    this.searchQuery = '',
    this.errorMessage,
  });

  ConnectionsState copyWith({
    ConnectionsStatus? status,
    List<PeerEntity>? connections,
    bool? hasMore,
    bool? isLoadingMore,
    int? page,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ConnectionsState(
      status: status ?? this.status,
      connections: connections ?? this.connections,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        connections,
        hasMore,
        isLoadingMore,
        page,
        searchQuery,
        errorMessage,
      ];
}
