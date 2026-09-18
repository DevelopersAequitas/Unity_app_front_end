import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/business_deal_entity.dart';
import '../../domain/usecases/get_given_business_deals_usecase.dart';
import '../../domain/usecases/get_received_business_deals_usecase.dart';
import '../../domain/usecases/get_user_business_deals_usecase.dart';
import '../bloc/business_deals_bloc.dart';
import '../bloc/business_deals_event.dart';
import '../bloc/business_deals_state.dart';
import '../widgets/add_business_deal_fab.dart';
import '../widgets/business_deal_empty_state.dart';
import '../widgets/business_deal_error_view.dart';
import '../widgets/business_deal_list_view.dart';
import '../widgets/business_deal_skeleton_list.dart';
import '../widgets/business_deal_success_sheet.dart';
import '../widgets/business_deals_bottom_nav.dart';

class BusinessDealsScreen extends StatelessWidget {
  final bool isModal;

  const BusinessDealsScreen({
    super.key,
    this.isModal = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => BusinessDealsBloc(
        getReceivedBusinessDealsUseCase:
            ctx.read<GetReceivedBusinessDealsUseCase>(),
        getGivenBusinessDealsUseCase: ctx.read<GetGivenBusinessDealsUseCase>(),
        getUserBusinessDealsUseCase: ctx.read<GetUserBusinessDealsUseCase>(),
      )..add(const BusinessDealsFetchReceivedRequested()),
      child: _BusinessDealsView(isModal: isModal),
    );
  }
}

class _BusinessDealsView extends StatefulWidget {
  final bool isModal;

  const _BusinessDealsView({required this.isModal});

  @override
  State<_BusinessDealsView> createState() => _BusinessDealsViewState();
}

class _BusinessDealsViewState extends State<_BusinessDealsView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<BusinessDealsBloc>();
      if (bloc.state.activeTab == BusinessDealTab.received) {
        bloc.add(const BusinessDealsLoadMoreReceivedRequested());
      } else {
        bloc.add(const BusinessDealsLoadMoreGivenRequested());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddBusinessDeal() async {
    final result =
        await Navigator.pushNamed(context, AppRoutes.addBusinessDeal);
    if (!mounted || result == null) return;

    if (result is Map && result['success'] == true) {
      final createdDeal = result['deal'];
      final coins = (result['coinsEarned'] as int?) ??
          (createdDeal is BusinessDealEntity ? createdDeal.coinsEarned : null);
      final impact = (result['impactEarned'] as int?) ??
          (createdDeal is BusinessDealEntity ? createdDeal.impactEarned : null);

      // Switch to Given tab so the user sees their newly added deal
      context.read<BusinessDealsBloc>().add(
            const BusinessDealsTabChanged(BusinessDealTab.given),
          );

      if (createdDeal is BusinessDealEntity) {
        context.read<BusinessDealsBloc>().add(
              BusinessDealCreatedLocally(createdDeal),
            );
      }

      // Sync fresh data from backend
      context.read<BusinessDealsBloc>().add(
            const BusinessDealsFetchGivenRequested(forceRefresh: true),
          );

      if (mounted) {
        BusinessDealSuccessSheet.show(
          context,
          coinsEarned: coins,
          impactEarned: impact,
          onDone: () {
            Navigator.pop(context); // Close celebration bottom sheet
          },
          onAddAnother: () {
            Navigator.pop(context); // Close celebration bottom sheet
            _openAddBusinessDeal(); // Re-open Add Business Deal
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: 'Business Deals',
        showBack: Navigator.canPop(context),
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search by peer, city, amount, company...',
        onSearchTap: () {
          setState(() => _isSearching = true);
        },
        onSearchChanged: (query) {
          context
              .read<BusinessDealsBloc>()
              .add(BusinessDealsSearchChanged(query));
        },
        onSearchClose: () {
          _searchController.clear();
          context
              .read<BusinessDealsBloc>()
              .add(const BusinessDealsSearchChanged(''));
          setState(() => _isSearching = false);
        },
        showNotifications: false,
        showProfile: true,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap:
            Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveContainer(
          child: BlocConsumer<BusinessDealsBloc, BusinessDealsState>(
            listener: (context, state) {
              if (state.currentStatus == BusinessDealsStatus.failure &&
                  state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final activeTab = state.activeTab;
              final status = state.currentStatus;
              final list = state.currentList;

              return Stack(
                children: [
                  _buildBodyContent(
                    context,
                    activeTab: activeTab,
                    status: status,
                    list: list,
                    searchQuery: state.searchQuery,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BusinessDealsBottomNav(
                      activeTab: activeTab,
                      onTabChanged: (tab) {
                        context.read<BusinessDealsBloc>().add(
                              BusinessDealsTabChanged(tab),
                            );
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 34,
                    child: Center(
                      child: AddBusinessDealFab(
                        onTap: _openAddBusinessDeal,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context, {
    required BusinessDealTab activeTab,
    required BusinessDealsStatus status,
    required List<BusinessDealEntity> list,
    required String searchQuery,
  }) {
    if (status == BusinessDealsStatus.loading && list.isEmpty) {
      return const BusinessDealSkeletonList();
    }

    if (status == BusinessDealsStatus.failure && list.isEmpty) {
      return BusinessDealErrorView(
        onRetry: () {
          if (activeTab == BusinessDealTab.received) {
            context.read<BusinessDealsBloc>().add(
                  const BusinessDealsFetchReceivedRequested(forceRefresh: true),
                );
          } else {
            context.read<BusinessDealsBloc>().add(
                  const BusinessDealsFetchGivenRequested(forceRefresh: true),
                );
          }
        },
      );
    }

    if (list.isEmpty) {
      return BusinessDealEmptyState(
        tab: activeTab,
        searchQuery: searchQuery,
        onActionTap: _openAddBusinessDeal,
      );
    }

    return BusinessDealListView(
      deals: list,
      tabType: activeTab == BusinessDealTab.received ? 'received' : 'given',
      scrollController: _scrollController,
      isLoadingMore: context.select<BusinessDealsBloc, bool>(
        (b) => b.state.isLoadingMore,
      ),
      onRefresh: () async {
        if (activeTab == BusinessDealTab.received) {
          context.read<BusinessDealsBloc>().add(
                const BusinessDealsFetchReceivedRequested(forceRefresh: true),
              );
        } else {
          context.read<BusinessDealsBloc>().add(
                const BusinessDealsFetchGivenRequested(forceRefresh: true),
              );
        }
      },
    );
  }
}
