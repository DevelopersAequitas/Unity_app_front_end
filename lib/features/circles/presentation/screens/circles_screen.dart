import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../bloc/circles_bloc.dart';
import '../bloc/circles_event.dart';
import '../bloc/circles_state.dart';
import '../widgets/active_request_prompt_sheet.dart';
import '../widgets/circles_bottom_bar.dart';
import '../widgets/circles_skeleton_loader.dart';
import '../widgets/join_circle_view.dart';
import '../widgets/my_circles_view.dart';
import '../widgets/my_requests_view.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CirclesBloc>();
    if (bloc.state.status == CirclesStatus.initial) {
      bloc.add(const CirclesFetchRequested());
    }
    _startRealtimeSync();
  }

  void _startRealtimeSync() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      context.read<CirclesBloc>().add(const CirclesRefreshRequested());
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchClose() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<CirclesBloc>().add(const CirclesSearchChanged(''));
  }

  String _getAppTitle(int activeTab) {
    if (activeTab == 0) return 'My Circles';
    if (activeTab == 1) return 'Join a Circle';
    return 'My Requests';
  }

  String _getSearchHint(int activeTab) {
    if (activeTab == 0) return 'Search my circles by name, category...';
    if (activeTab == 1) return 'Search categories, sectors...';
    return 'Search my requests...';
  }

  void _handleCategoryTap(CircleCategoryEntity category, CirclesState state) {
    final req = state.getJoinRequestForCategory(category);
    if (req != null && !req.isRejected) {
      ActiveRequestPromptSheet.show(
        context: context,
        categoryName: category.name,
        request: req,
        onSeeRequest: () {
          Navigator.pop(context);
          _navigateToStatus(req.id, req.categoryName.isNotEmpty ? req.categoryName : category.name);
        },
        onSubmitAgain: () {
          Navigator.pop(context);
          _navigateToSubcategories(category.id.toString(), category.name);
        },
      );
    } else {
      _navigateToSubcategories(category.id.toString(), category.name);
    }
  }

  void _navigateToStatus(String requestId, String circleName) {
    Navigator.pushNamed(
      context,
      AppRoutes.joinRequestStatus,
      arguments: {'requestId': requestId, 'circleName': circleName},
    ).then((_) {
      if (mounted) context.read<CirclesBloc>().add(const CirclesRefreshRequested());
    });
  }

  void _navigateToSubcategories(String circleId, String circleName) {
    Navigator.pushNamed(
      context,
      AppRoutes.circleSubcategories,
      arguments: {'circleId': circleId, 'circleName': circleName},
    ).then((_) {
      if (mounted) context.read<CirclesBloc>().add(const CirclesRefreshRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CirclesBloc, CirclesState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null && prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.transparent,
          appBar: AppCommonBar(
            title: _getAppTitle(state.activeTab),
            showBack: true,
            showSearch: true,
            showNotifications: false,
            showProfile: false,
            isSearching: _isSearching,
            searchController: _searchController,
            searchHint: _getSearchHint(state.activeTab),
            onSearchTap: () => setState(() => _isSearching = true),
            onSearchClose: _onSearchClose,
            onSearchChanged: (query) {
              context.read<CirclesBloc>().add(CirclesSearchChanged(query));
            },
            onBackTap: () => Navigator.of(context).pop(),
          ),
          bottomNavigationBar: CirclesBottomBar(
            activeTab: state.activeTab,
            myCirclesCount: state.myCircles.length,
            myRequestsCount: state.activeJoinRequests.length,
            onTabSelected: (index) {
              context.read<CirclesBloc>().add(CirclesTabChanged(index));
            },
          ),
          body: AppGradientBackground(
            child: ResponsiveContainer(
              child: RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context.read<CirclesBloc>().add(const CirclesRefreshRequested());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    if (state.status == CirclesStatus.loading &&
                        state.myCircles.isEmpty &&
                        state.categories.isEmpty &&
                        state.myJoinRequests.isEmpty)
                      const CirclesSkeletonLoader()
                    else if (state.activeTab == 0)
                      MyCirclesView(
                        circles: state.filteredMyCircles,
                        searchQuery: state.searchQuery,
                        onCircleTap: (circle) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.circleDetails,
                            arguments: circle,
                          );
                        },
                        onExploreTap: () {
                          context.read<CirclesBloc>().add(const CirclesTabChanged(1));
                        },
                      )
                    else if (state.activeTab == 1)
                      JoinCircleView(
                        industryCategories: state.industryCategories,
                        interestCategories: state.interestCategories,
                        joinRequestResolver: (category) =>
                            state.getJoinRequestForCategory(category),
                        onCategoryTap: (cat) => _handleCategoryTap(cat, state),
                      )
                    else
                      MyRequestsView(
                        requests: state.filteredMyJoinRequests,
                        searchQuery: state.searchQuery,
                        onRequestTap: (req) => _navigateToStatus(
                          req.id,
                          req.categoryName.isNotEmpty ? req.categoryName : req.circleName,
                        ),
                        onExploreTap: () {
                          context.read<CirclesBloc>().add(const CirclesTabChanged(1));
                        },
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
