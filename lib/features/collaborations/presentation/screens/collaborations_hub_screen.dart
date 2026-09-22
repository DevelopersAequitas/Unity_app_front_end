import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/collaborations_bloc.dart';
import '../bloc/collaborations_event.dart';
import '../bloc/collaborations_state.dart';
import '../widgets/add_collaboration_fab.dart';
import '../widgets/collaborations_bottom_nav.dart';
import '../widgets/collaborations_list_tab.dart';
import 'add_collaboration_screen.dart';

class CollaborationsHubScreen extends StatefulWidget {
  final int initialTabIndex;

  const CollaborationsHubScreen({super.key, this.initialTabIndex = 0});

  @override
  State<CollaborationsHubScreen> createState() => _CollaborationsHubScreenState();
}

class _CollaborationsHubScreenState extends State<CollaborationsHubScreen> {
  late CollaborationTab _activeTab;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  String _statusFilter = 'all'; // 'all', 'open', 'completed'

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex == 1 || widget.initialTabIndex == 2
        ? CollaborationTab.myHistory
        : CollaborationTab.opportunities;

    context.read<CollaborationsBloc>().add(const LoadCollaborationsInitialData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddCollaboration() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCollaborationScreen(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      // Switch to My Asks so user sees their new collaboration
      setState(() {
        _activeTab = CollaborationTab.myHistory;
      });
      context.read<CollaborationsBloc>().add(const FetchCollaborationHistoryEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<CollaborationsBloc, CollaborationsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == CollaborationsStatus.success || curr.status == CollaborationsStatus.error),
      listener: (context, state) {
        if (state.status == CollaborationsStatus.success && state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
        } else if (state.status == CollaborationsStatus.error && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
        appBar: AppCommonBar(
          title: 'Collaborations',
          showBack: Navigator.canPop(context),
          showSearch: true,
          isSearching: _isSearching,
          searchController: _searchController,
          searchHint: 'Search opportunities, industries, peers...',
          onSearchTap: () => setState(() => _isSearching = true),
          onSearchChanged: (query) => setState(() => _searchQuery = query),
          onSearchClose: () {
            _searchController.clear();
            setState(() {
              _searchQuery = '';
              _isSearching = false;
            });
          },
          onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
        ),
        body: SafeArea(
          top: false,
          child: AppGradientBackground(
            child: ResponsiveContainer(
              child: Column(
                children: [
                  // Status Filter Chips Row
                  _buildStatusFilterRow(isDark),

                  // Main Tab Content with Bottom Nav Stack
                  Expanded(
                    child: Stack(
                      children: [
                        // Tab Content
                        Positioned.fill(
                          child: CollaborationsListTab(
                            isHistoryOnly: _activeTab == CollaborationTab.myHistory,
                            statusFilter: _statusFilter,
                            searchQuery: _searchQuery,
                            onPostTap: _openAddCollaboration,
                          ),
                        ),

                        // Bottom Navigation Bar
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: CollaborationsBottomNav(
                            activeTab: _activeTab,
                            onTabChanged: (tab) {
                              setState(() {
                                _activeTab = tab;
                              });
                            },
                          ),
                        ),

                        // Centered Floating Action Button for Add Ask
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 34,
                          child: Center(
                            child: AddCollaborationFab(
                              onTap: _openAddCollaboration,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilterRow(bool isDark) {
    final filters = [
      {'id': 'all', 'label': 'All'},
      {'id': 'open', 'label': 'Open'},
      {'id': 'completed', 'label': 'Completed'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final isSelected = _statusFilter == f['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _statusFilter = f['id']!;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColor.brandGradient : null,
                  color: isSelected
                      ? null
                      : (isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurface),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primaryPink.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  f['label']!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
