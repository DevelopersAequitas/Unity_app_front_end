import 'package:equatable/equatable.dart';
import '../../domain/entities/peer_entity.dart';

enum PeersStatus { initial, loading, success, failure }

class PeersState extends Equatable {
  final PeersStatus status;
  final List<PeerEntity> allPeers;
  final List<PeerEntity> bookmarkedPeersList;
  final bool isLoadingBookmarks;
  final bool hasMore;
  final bool isLoadingMore;
  final int page;
  final String searchQuery;
  final String selectedSort;
  final String? errorMessage;

  const PeersState({
    this.status = PeersStatus.initial,
    this.allPeers = const [],
    this.bookmarkedPeersList = const [],
    this.isLoadingBookmarks = false,
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
  List<PeerEntity> get peers {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return allPeers.where(_isNotConnected).toList();
    }
    return allPeers.where((p) => _matchesQuery(p, q)).toList();
  }

  /// Returns bookmarked peers fetched from /bookmarked-peers or local bookmarks.
  List<PeerEntity> get bookmarkedPeers {
    final q = searchQuery.trim().toLowerCase();
    final sourceList = bookmarkedPeersList.isNotEmpty
        ? bookmarkedPeersList
        : allPeers.where((p) => p.isBookmarked).toList();

    if (q.isEmpty) return sourceList;
    return sourceList.where((p) => _matchesQuery(p, q)).toList();
  }

  static bool _matchesQuery(PeerEntity p, String q) {
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
  }

  PeersState copyWith({
    PeersStatus? status,
    List<PeerEntity>? allPeers,
    List<PeerEntity>? bookmarkedPeersList,
    bool? isLoadingBookmarks,
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
      bookmarkedPeersList: bookmarkedPeersList ?? this.bookmarkedPeersList,
      isLoadingBookmarks: isLoadingBookmarks ?? this.isLoadingBookmarks,
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
        bookmarkedPeersList,
        isLoadingBookmarks,
        hasMore,
        isLoadingMore,
        page,
        searchQuery,
        selectedSort,
        errorMessage,
      ];
}
