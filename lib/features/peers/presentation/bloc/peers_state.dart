import 'package:equatable/equatable.dart';
import '../../domain/entities/peer_entity.dart';

enum PeersStatus { initial, loading, success, failure }

class PeersState extends Equatable {
  final PeersStatus status;
  final List<PeerEntity> peers;
  final bool hasMore;
  final bool isLoadingMore;
  final int page;
  final String searchQuery;
  final String selectedSort;
  final String? errorMessage;

  const PeersState({
    this.status = PeersStatus.initial,
    this.peers = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.page = 1,
    this.searchQuery = '',
    this.selectedSort = 'Most Recent',
    this.errorMessage,
  });

  PeersState copyWith({
    PeersStatus? status,
    List<PeerEntity>? peers,
    bool? hasMore,
    bool? isLoadingMore,
    int? page,
    String? searchQuery,
    String? selectedSort,
    String? errorMessage,
  }) {
    return PeersState(
      status: status ?? this.status,
      peers: peers ?? this.peers,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSort: selectedSort ?? this.selectedSort,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        peers,
        hasMore,
        isLoadingMore,
        page,
        searchQuery,
        selectedSort,
        errorMessage,
      ];
}
