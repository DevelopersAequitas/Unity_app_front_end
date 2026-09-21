import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/business_deal/domain/usecases/get_business_deals_leaderboard_usecase.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/usecases/get_given_business_deals_usecase.dart';
import '../../domain/usecases/get_received_business_deals_usecase.dart';
import '../../domain/usecases/get_user_business_deals_usecase.dart';
import '../bloc/business_deals_bloc.dart';
import '../bloc/business_deals_event.dart';
import '../bloc/business_deals_state.dart';
import '../widgets/business_deal_card.dart';
import '../widgets/business_deal_empty_state.dart';
import '../widgets/business_deal_error_view.dart';
import '../widgets/business_deal_skeleton_list.dart';

class PeerBusinessDealsScreen extends StatelessWidget {
  final String peerId;
  final String peerName;

  const PeerBusinessDealsScreen({
    super.key,
    required this.peerId,
    this.peerName = 'Peer',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => BusinessDealsBloc(
        getReceivedBusinessDealsUseCase: ctx
            .read<GetReceivedBusinessDealsUseCase>(),
        getGivenBusinessDealsUseCase: ctx.read<GetGivenBusinessDealsUseCase>(),
        getUserBusinessDealsUseCase: ctx.read<GetUserBusinessDealsUseCase>(),
        getBusinessDealsLeaderboardUseCase: ctx
            .read<GetBusinessDealsLeaderboardUseCase>(),
      )..add(BusinessDealsFetchUserRequested(peerId)),
      child: _PeerBusinessDealsView(peerId: peerId, peerName: peerName),
    );
  }
}

class _PeerBusinessDealsView extends StatefulWidget {
  final String peerId;
  final String peerName;

  const _PeerBusinessDealsView({required this.peerId, required this.peerName});

  @override
  State<_PeerBusinessDealsView> createState() => _PeerBusinessDealsViewState();
}

class _PeerBusinessDealsViewState extends State<_PeerBusinessDealsView> {
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
      context.read<BusinessDealsBloc>().add(
        BusinessDealsLoadMoreUserRequested(widget.peerId),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildStatsHeader(BusinessDealsState state) {
    final pagination = state.userPagination;
    final given = pagination.businessDealsGiven;
    final received = pagination.businessDealsReceived;
    final total = pagination.totalBusinessDeals;

    if (given == null && received == null && total == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Given', (given ?? 0).toString()),
          Container(width: 1, height: 24, color: AppColor.lightBorder),
          _buildStatItem('Received', (received ?? 0).toString()),
          Container(width: 1, height: 24, color: AppColor.lightBorder),
          _buildStatItem(
            'Total Deals',
            (total ?? (given ?? 0) + (received ?? 0)).toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColor.primaryBlue,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 11,
            color: AppColor.lightTextTertiary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.peerName.isNotEmpty && widget.peerName != 'Peer'
        ? '${widget.peerName.toUpperCase()}\'S DEALS'
        : 'BUSINESS DEALS';

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: title,
        showBack: true,
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search by peer name, city, amount...',
        onSearchTap: () {
          setState(() => _isSearching = true);
        },
        onSearchChanged: (query) {
          context.read<BusinessDealsBloc>().add(
            BusinessDealsSearchChanged(query),
          );
        },
        onSearchClose: () {
          _searchController.clear();
          context.read<BusinessDealsBloc>().add(
            const BusinessDealsSearchChanged(''),
          );
          setState(() => _isSearching = false);
        },
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.pop(context),
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveContainer(
          child: BlocConsumer<BusinessDealsBloc, BusinessDealsState>(
            listener: (context, state) {
              if (state.receivedStatus == BusinessDealsStatus.failure &&
                  state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final status = state.receivedStatus;
              final list = state.filteredUserDeals;

              if (status == BusinessDealsStatus.loading &&
                  state.userDeals.isEmpty) {
                return const BusinessDealSkeletonList();
              }

              if (status == BusinessDealsStatus.failure &&
                  state.userDeals.isEmpty) {
                return BusinessDealErrorView(
                  onRetry: () {
                    context.read<BusinessDealsBloc>().add(
                      BusinessDealsFetchUserRequested(widget.peerId),
                    );
                  },
                );
              }

              if (list.isEmpty) {
                return BusinessDealEmptyState(
                  tab: BusinessDealTab.received,
                  searchQuery: state.searchQuery,
                );
              }

              final extraItem = state.isLoadingMore ? 1 : 0;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BusinessDealsBloc>().add(
                    BusinessDealsFetchUserRequested(widget.peerId),
                  );
                },
                color: AppColor.primaryBlue,
                child: Column(
                  children: [
                    _buildStatsHeader(state),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: list.length + extraItem,
                        itemBuilder: (context, index) {
                          if (index < list.length) {
                            final item = list[index];
                            return BusinessDealCard(
                              deal: item,
                              tabType: 'received',
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
