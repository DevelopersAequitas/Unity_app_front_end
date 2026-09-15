import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/circle_closed_category_entity.dart';
import '../../domain/entities/circle_entity.dart';
import '../../domain/entities/circle_open_category_entity.dart';
import '../../domain/entities/flat_open_category_item.dart';
import '../../domain/usecases/get_circle_closed_categories_usecase.dart';
import '../../domain/usecases/get_circle_open_categories_usecase.dart';
import '../widgets/circle_categories/circle_categories_tab_bar.dart';
import '../widgets/circle_categories/circle_closed_categories_tab.dart';
import '../widgets/circle_categories/circle_open_categories_tab.dart';

class CircleCategoriesScreen extends StatefulWidget {
  final CircleEntity circle;
  final int initialTabIndex;
  final List<CircleOpenCategoryEntity>? preloadedOpen;
  final List<CircleClosedCategoryEntity>? preloadedClosed;

  const CircleCategoriesScreen({
    super.key,
    required this.circle,
    this.initialTabIndex = 0,
    this.preloadedOpen,
    this.preloadedClosed,
  });

  @override
  State<CircleCategoriesScreen> createState() => _CircleCategoriesScreenState();
}

class _CircleCategoriesScreenState extends State<CircleCategoriesScreen>
  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<FlatOpenCategoryItem> _flatOpenCategories = [];
  List<CircleClosedCategoryEntity> _closedCategories = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );

    if (widget.preloadedOpen != null &&
        widget.preloadedClosed != null &&
        (widget.preloadedOpen!.isNotEmpty ||
            widget.preloadedClosed!.isNotEmpty)) {
      _flatOpenCategories = _extractLevel4OpenCategories(widget.preloadedOpen!);
      _closedCategories = widget.preloadedClosed!;
      _isLoading = false;
    } else {
      _loadCategories();
    }
    _setupBusSubscription();
  }

  void _setupBusSubscription() {
    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      if (event is PeerConnectionRequestedEvent) {
        _updateOccupantStatus(event.peerId,
            status: 'pending', isRequested: true, isConnected: false);
      } else if (event is PeerConnectionAcceptedEvent) {
        _updateOccupantStatus(event.peerId,
            status: 'connected', isRequested: false, isConnected: true);
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        final peerId = event is PeerConnectionDeclinedEvent
            ? event.peerId
            : (event as PeerConnectionCancelledEvent).peerId;
        _updateOccupantStatus(peerId,
            status: 'none', isRequested: false, isConnected: false);
      } else if (event is PeerFollowToggledEvent) {
        setState(() {
          _closedCategories = _closedCategories.map((c) {
            if (c.occupantUserId == event.peerId || c.id == event.peerId) {
              return c.copyWith(occupantIsFollowing: event.isFollowing);
            }
            return c;
          }).toList();
        });
      } else if (event is PeerBookmarkToggledEvent) {
        setState(() {
          _closedCategories = _closedCategories.map((c) {
            if (c.occupantUserId == event.peerId || c.id == event.peerId) {
              return c.copyWith(occupantIsBookmarked: event.isBookmarked);
            }
            return c;
          }).toList();
        });
      }
    });
  }

  void _updateOccupantStatus(
    String peerId, {
    required String status,
    required bool isRequested,
    required bool isConnected,
  }) {
    setState(() {
      _closedCategories = _closedCategories.map((c) {
        if (c.occupantUserId == peerId || c.id == peerId) {
          return c.copyWith(
            occupantConnectionStatus: status,
            occupantIsRequested: isRequested,
            occupantIsConnected: isConnected,
          );
        }
        return c;
      }).toList();
    });
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<FlatOpenCategoryItem> _extractLevel4OpenCategories(
      List<CircleOpenCategoryEntity> roots) {
    final List<FlatOpenCategoryItem> results = [];
    for (final l2 in roots) {
      if (l2.children.isEmpty) {
        if (!l2.isClosed) {
          results.add(FlatOpenCategoryItem(
            id: l2.id,
            name: l2.name,
            sectorName: l2.name,
          ));
        }
      } else {
        for (final l3 in l2.children) {
          if (l3.children.isEmpty) {
            if (!l3.isClosed) {
              results.add(FlatOpenCategoryItem(
                id: l3.id,
                name: l3.name,
                sectorName: l2.name,
                subcategoryName: null,
              ));
            }
          } else {
            for (final l4 in l3.children) {
              if (!l4.isClosed) {
                results.add(FlatOpenCategoryItem(
                  id: l4.id,
                  name: l4.name,
                  sectorName: l2.name,
                  subcategoryName: l3.name,
                ));
              }
            }
          }
        }
      }
    }
    return results;
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final openUseCase = context.read<GetCircleOpenCategoriesUseCase>();
      final closedUseCase = context.read<GetCircleClosedCategoriesUseCase>();

      final results = await Future.wait<dynamic>([
        openUseCase(widget.circle.id)
            .catchError((_) => <CircleOpenCategoryEntity>[]),
        closedUseCase(widget.circle.id)
            .catchError((_) => <CircleClosedCategoryEntity>[]),
      ]);

      if (!mounted) return;
      setState(() {
        _flatOpenCategories = _extractLevel4OpenCategories(
            results[0] as List<CircleOpenCategoryEntity>);
        _closedCategories = results[1] as List<CircleClosedCategoryEntity>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<FlatOpenCategoryItem> _getFilteredOpen(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _flatOpenCategories;
    return _flatOpenCategories.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.sectorName.toLowerCase().contains(q) ||
          (item.subcategoryName ?? '').toLowerCase().contains(q);
    }).toList();
  }

  List<CircleClosedCategoryEntity> _getFilteredClosed(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _closedCategories;
    return _closedCategories.where((c) {
      final qList = [
        c.name,
        c.level2Name ?? '',
        c.level3Name ?? '',
        c.occupantName ?? '',
        c.occupantCompany ?? '',
        c.occupantDesignation ?? '',
        c.occupantCity ?? '',
      ].map((e) => e.toLowerCase());
      return qList.any((field) => field.contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final query = _searchController.text.trim();
    final openFiltered = _getFilteredOpen(query);
    final closedFiltered = _getFilteredClosed(query);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: '${widget.circle.name} Categories',
        showBack: true,
        showSearch: true,
        showNotifications: false,
        showProfile: false,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search categories, sectors, peers...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchClose: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        },
        onSearchChanged: (_) => setState(() {}),
        onBackTap: () => Navigator.of(context).pop(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CircleCategoriesTabBar(
              controller: _tabController,
              openCount: query.isEmpty
                  ? _flatOpenCategories.length
                  : openFiltered.length,
              closedCount: query.isEmpty
                  ? _closedCategories.length
                  : closedFiltered.length,
            ),
          ),
        ),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: Column(
            children: [
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.primaryBlue,
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                        fontSize: 13, color: secondaryText),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: _loadCategories,
                                    child: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              CircleOpenCategoriesTab(
                                openFiltered: openFiltered,
                                closedFiltered: closedFiltered,
                                circle: widget.circle,
                                query: query,
                                onRefresh: _loadCategories,
                                onSwitchToClosed: () =>
                                    _tabController.animateTo(1),
                              ),
                              CircleClosedCategoriesTab(
                                closedFiltered: closedFiltered,
                                openFiltered: openFiltered,
                                query: query,
                                onRefresh: _loadCategories,
                                onSwitchToOpen: () =>
                                    _tabController.animateTo(0),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
