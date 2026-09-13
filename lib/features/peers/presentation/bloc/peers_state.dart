import 'package:equatable/equatable.dart';
import '../../domain/entities/peer_entity.dart';

enum PeersStatus { initial, loading, success, failure }

class PeersState extends Equatable {
  final PeersStatus status;
  final List<PeerEntity> allPeers;
  final bool hasMore;
  final bool isLoadingMore;
  final int page;
  final String searchQuery;
  final String selectedSort;
  final String? errorMessage;

  const PeersState({
    this.status = PeersStatus.initial,
    this.allPeers = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.page = 1,
    this.searchQuery = '',
    this.selectedSort = 'Most Recent',
    this.errorMessage,
  });

  static bool _isNotConnected(PeerEntity p) {
    final status = p.connectionStatus.toLowerCase();
    return status != 'connected' &&
        status != 'approved' &&
        status != 'accepted' &&
        status != 'is_connected';
  }

  /// Returns filtered peers based on searchQuery.
  /// When not searching (browsing/scrolling), excludes already-connected peers so user discovers new peers.
  /// When searching, includes all matching peers (both connected and non-connected) from the directory.
  List<PeerEntity> get peers {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return allPeers.where(_isNotConnected).toList();
    }
    return allPeers.where((p) {
      final name = p.displayName.toLowerCase();
      final firstName = (p.firstName ?? '').toLowerCase();
      final lastName = (p.lastName ?? '').toLowerCase();
      final company = (p.companyName ?? '').toLowerCase();
      final designation = (p.designation ?? '').toLowerCase();
      final category = (p.category ?? '').toLowerCase();
      final city = (p.city ?? '').toLowerCase();

      return name.contains(q) ||
          firstName.contains(q) ||
          lastName.contains(q) ||
          company.contains(q) ||
          designation.contains(q) ||
          category.contains(q) ||
          city.contains(q);
    }).toList();
  }

  PeersState copyWith({
    PeersStatus? status,
    List<PeerEntity>? allPeers,
    bool? hasMore,
    bool? isLoadingMore,
    int? page,
    String? searchQuery,
    String? selectedSort,
    String? errorMessage,
  }) {
    return PeersState(
      status: status ?? this.status,
      allPeers: allPeers ?? this.allPeers,
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
        allPeers,
        hasMore,
        isLoadingMore,
        page,
        searchQuery,
        selectedSort,
        errorMessage,
      ];
}
