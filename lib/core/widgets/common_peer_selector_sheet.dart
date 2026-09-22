import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/peers/domain/entities/peer_entity.dart';
import '../../features/peers/domain/usecases/get_all_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_my_connections_usecase.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'app_avatar.dart';

class CommonPeerSelectorSheet extends StatefulWidget {
  final GetAllPeersUseCase getAllPeersUseCase;
  final GetMyConnectionsUseCase? getMyConnectionsUseCase;
  final String? selectedPeerId;
  final String title;
  final ValueChanged<PeerEntity> onSelect;

  const CommonPeerSelectorSheet({
    super.key,
    required this.getAllPeersUseCase,
    this.getMyConnectionsUseCase,
    this.selectedPeerId,
    this.title = 'Select Peer',
    required this.onSelect,
  });

  static Future<PeerEntity?> show(
    BuildContext context, {
    GetAllPeersUseCase? getAllPeersUseCase,
    GetMyConnectionsUseCase? getMyConnectionsUseCase,
    String? selectedPeerId,
    String title = 'Select Peer',
  }) {
    final allPeersUseCase = getAllPeersUseCase ?? context.read<GetAllPeersUseCase>();
    GetMyConnectionsUseCase? myConnUseCase = getMyConnectionsUseCase;
    if (myConnUseCase == null) {
      try {
        myConnUseCase = context.read<GetMyConnectionsUseCase>();
      } catch (_) {}
    }

    return showModalBottomSheet<PeerEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CommonPeerSelectorSheet(
        getAllPeersUseCase: allPeersUseCase,
        getMyConnectionsUseCase: myConnUseCase,
        selectedPeerId: selectedPeerId,
        title: title,
        onSelect: (peer) => Navigator.of(ctx).pop(peer),
      ),
    );
  }

  @override
  State<CommonPeerSelectorSheet> createState() => _CommonPeerSelectorSheetState();
}

class _CommonPeerSelectorSheetState extends State<CommonPeerSelectorSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  List<PeerEntity> _allLoadedPeers = [];
  List<PeerEntity> _displayedPeers = [];
  int _currentPage = 1;
  static const int _limit = 20;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialPeers();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 250 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMorePeers();
    }
  }

  bool _isGenie(PeerEntity peer) {
    final displayName = peer.displayName.toLowerCase();
    final first = (peer.firstName ?? '').toLowerCase();
    final last = (peer.lastName ?? '').toLowerCase();
    final company = (peer.companyName ?? '').toLowerCase();
    return displayName.contains('genie') ||
        first.contains('genie') ||
        last.contains('genie') ||
        company.contains('peersglobal genie');
  }

  bool _matchesSearch(PeerEntity peer, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    final displayName = peer.displayName.toLowerCase();
    final first = (peer.firstName ?? '').toLowerCase();
    final last = (peer.lastName ?? '').toLowerCase();
    final company = (peer.companyName ?? '').toLowerCase();
    final designation = (peer.designation ?? '').toLowerCase();
    final city = (peer.city ?? '').toLowerCase();
    final category = (peer.category ?? '').toLowerCase();

    return displayName.contains(q) ||
        first.contains(q) ||
        last.contains(q) ||
        company.contains(q) ||
        designation.contains(q) ||
        city.contains(q) ||
        category.contains(q);
  }

  List<PeerEntity> _cleanAndDeduplicate(List<PeerEntity> list) {
    final seen = <String>{};
    final cleaned = <PeerEntity>[];
    for (final p in list) {
      if (!_isGenie(p) && seen.add(p.id)) {
        cleaned.add(p);
      }
    }
    return cleaned;
  }

  Future<void> _fetchInitialPeers() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = 1;
      _hasMore = true;
    });

    final query = _searchCtrl.text.trim();

    try {
      final futures = <Future<List<PeerEntity>>>[];

      // 1. Fetch connected peers if available
      if (widget.getMyConnectionsUseCase != null) {
        futures.add(
          widget.getMyConnectionsUseCase!(
            page: 1,
            limit: 30,
            search: query.isNotEmpty ? query : null,
          ).catchError((_) => <PeerEntity>[]),
        );
      }

      // 2. Fetch all members
      futures.add(
        widget.getAllPeersUseCase(
          page: 1,
          limit: _limit,
          search: query.isNotEmpty ? query : null,
        ).catchError((_) => <PeerEntity>[]),
      );

      final resultsLists = await Future.wait(futures);
      final combined = <PeerEntity>[];
      for (final list in resultsLists) {
        combined.addAll(list);
      }

      var filtered = _cleanAndDeduplicate(combined);
      if (query.isNotEmpty) {
        filtered = filtered.where((p) => _matchesSearch(p, query)).toList();
      }

      if (mounted) {
        setState(() {
          _allLoadedPeers = filtered;
          _displayedPeers = filtered;
          _isLoading = false;
          _hasMore = resultsLists.any((l) => l.length >= _limit);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load peers. Please try again.';
        });
      }
    }
  }

  Future<void> _loadMorePeers() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    final query = _searchCtrl.text.trim();

    try {
      final results = await widget.getAllPeersUseCase(
        page: nextPage,
        limit: _limit,
        search: query.isNotEmpty ? query : null,
      );

      var filtered = _cleanAndDeduplicate(results);
      if (query.isNotEmpty) {
        filtered = filtered.where((p) => _matchesSearch(p, query)).toList();
      }

      if (mounted) {
        final existingIds = _allLoadedPeers.map((p) => p.id).toSet();
        final newUnique = filtered.where((p) => !existingIds.contains(p.id)).toList();

        setState(() {
          _currentPage = nextPage;
          _allLoadedPeers.addAll(newUnique);
          _displayedPeers = _cleanAndDeduplicate([..._displayedPeers, ...newUnique]);
          _isLoadingMore = false;
          _hasMore = results.length >= _limit;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    // Instant local filtering for zero lag
    final query = value.trim();
    if (query.isNotEmpty) {
      final localMatches = _allLoadedPeers.where((p) => _matchesSearch(p, query)).toList();
      setState(() {
        _displayedPeers = localMatches;
      });
    } else {
      setState(() {
        _displayedPeers = _allLoadedPeers;
      });
    }

    // Debounced remote API search
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _fetchInitialPeers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height * 0.82;

    return Material(
      color: AppColor.transparent,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header Row: Title and Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.lightSurfaceSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColor.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColor.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search peer by name, company, or role...',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColor.lightTextTertiary,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColor.lightTextTertiary,
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          size: 18,
                          color: AppColor.lightTextSecondary,
                        ),
                        onPressed: () {
                          _searchCtrl.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColor.lightSurfaceSubtle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Body List
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _displayedPeers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColor.primaryBlue,
        ),
      );
    }

    if (_error != null && _displayedPeers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: AppColor.lightTextTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.lightTextTertiary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _fetchInitialPeers,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_displayedPeers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline_rounded,
              size: 40,
              color: AppColor.lightTextTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              'No peers found',
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _displayedPeers.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _displayedPeers.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          );
        }

        final peer = _displayedPeers[index];
        final isSelected = widget.selectedPeerId != null &&
            widget.selectedPeerId == peer.id;

        return _buildPeerCardItem(peer, isSelected);
      },
    );
  }

  Widget _buildPeerCardItem(PeerEntity peer, bool isSelected) {
    final hasDesignationOrCompany =
        (peer.designation != null && peer.designation!.trim().isNotEmpty) ||
        (peer.companyName != null && peer.companyName!.trim().isNotEmpty);
    final hasCity = peer.city != null && peer.city!.trim().isNotEmpty;
    final hasCategory =
        peer.category != null && peer.category!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.primaryBlue.withValues(alpha: 0.06)
            : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColor.primaryBlue.withValues(alpha: 0.5)
              : AppColor.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => widget.onSelect(peer),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with online & pro badges
                AppAvatar(
                  imageUrl: peer.profilePhotoUrl,
                  name: peer.displayName,
                  size: 38,
                  showOnlineBadge: true,
                  isOnline: peer.isOnline,
                  isPro: peer.isPro,
                ),
                const SizedBox(width: 8),

                // Peer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: UPPERCASE Name + verified + PRO badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              peer.displayName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.lightTextPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (peer.isVerified) ...[
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.verified_rounded,
                              size: 13,
                              color: AppColor.primaryBlue,
                            ),
                          ],
                          if (peer.isPro) ...[
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
                                  color: AppColor.white,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Row 2: City directly below peer name
                      if (hasCity) ...[
                        const SizedBox(height: 1.5),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 10,
                              color: AppColor.lightTextSecondary,
                            ),
                            const SizedBox(width: 2.5),
                            Text(
                              peer.city!.trim(),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColor.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],

                      // Row 3: Designation · Company
                      if (hasDesignationOrCompany) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.business_center_rounded,
                              size: 10,
                              color: AppColor.lightTextSecondary,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                [
                                  if (peer.designation != null &&
                                      peer.designation!.trim().isNotEmpty)
                                    peer.designation!.trim(),
                                  if (peer.companyName != null &&
                                      peer.companyName!.trim().isNotEmpty)
                                    peer.companyName!.trim(),
                                ].join(' · '),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColor.lightTextSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Row 4: Category
                      if (hasCategory) ...[
                        const SizedBox(height: 2.5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.badgeBlueBg,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColor.primaryBlue
                                  .withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sell_outlined,
                                size: 8.5,
                                color: AppColor.primaryBlue,
                              ),
                              const SizedBox(width: 2.5),
                              Flexible(
                                child: Text(
                                  peer.category!.trim(),
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primaryBlue,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Right Corner: Impact badge if available
                if (peer.lifeImpactedCount != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.lightSurfaceMuted,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColor.lightBorder.withValues(alpha: 0.8),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_rounded,
                          size: 13,
                          color: Color(0xFFD946EF),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${peer.lifeImpactedCount}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD946EF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
