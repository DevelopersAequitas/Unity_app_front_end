import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/testimonial_entity.dart';
import '../../domain/usecases/get_given_testimonials_usecase.dart';
import '../../domain/usecases/get_received_testimonials_usecase.dart';
import '../../domain/usecases/get_user_testimonials_usecase.dart';
import '../bloc/testimonials_bloc.dart';
import '../bloc/testimonials_event.dart';
import '../bloc/testimonials_state.dart';
import '../widgets/add_testimonial_fab.dart';
import '../widgets/testimonial_empty_state.dart';
import '../widgets/testimonial_error_view.dart';
import '../widgets/testimonial_list_view.dart';
import '../widgets/testimonial_skeleton_list.dart';
import '../widgets/testimonial_success_sheet.dart';
import '../widgets/testimonials_bottom_nav.dart';

class TestimonialsScreen extends StatelessWidget {
  final bool isModal;

  const TestimonialsScreen({
    super.key,
    this.isModal = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TestimonialsBloc(
        getReceivedTestimonialsUseCase:
            ctx.read<GetReceivedTestimonialsUseCase>(),
        getGivenTestimonialsUseCase: ctx.read<GetGivenTestimonialsUseCase>(),
        getUserTestimonialsUseCase: ctx.read<GetUserTestimonialsUseCase>(),
      )..add(const TestimonialsFetchReceivedRequested()),
      child: _TestimonialsView(isModal: isModal),
    );
  }
}

class _TestimonialsView extends StatefulWidget {
  final bool isModal;

  const _TestimonialsView({required this.isModal});

  @override
  State<_TestimonialsView> createState() => _TestimonialsViewState();
}

class _TestimonialsViewState extends State<_TestimonialsView> {
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
      final bloc = context.read<TestimonialsBloc>();
      if (bloc.state.activeTab == TestimonialTab.received) {
        bloc.add(const TestimonialsLoadMoreReceivedRequested());
      } else {
        bloc.add(const TestimonialsLoadMoreGivenRequested());
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

  Future<void> _openAddTestimonial() async {
    final result = await Navigator.pushNamed(context, AppRoutes.addTestimonial);
    if (!mounted || result == null) return;

    if (result is Map && result['success'] == true) {
      final createdTestimonial = result['testimonial'];
      final coins = (result['coinsEarned'] as int?) ??
          (createdTestimonial is TestimonialEntity
              ? createdTestimonial.coinsEarned
              : null);
      final impact = (result['impactEarned'] as int?) ??
          (createdTestimonial is TestimonialEntity
              ? createdTestimonial.impactEarned
              : null);

      // Switch to Given tab so the user sees their newly added testimonial
      context.read<TestimonialsBloc>().add(
            const TestimonialsTabChanged(TestimonialTab.given),
          );

      if (createdTestimonial is TestimonialEntity) {
        context.read<TestimonialsBloc>().add(
              TestimonialCreatedLocally(createdTestimonial),
            );
      }

      // Sync fresh data from backend
      context.read<TestimonialsBloc>().add(
            const TestimonialsFetchGivenRequested(forceRefresh: true),
          );

      if (mounted) {
        TestimonialSuccessSheet.show(
          context,
          coinsEarned: coins,
          impactEarned: impact,
          onDone: () {
            Navigator.pop(context); // Close celebration bottom sheet
          },
          onAddAnother: () {
            Navigator.pop(context); // Close celebration bottom sheet
            _openAddTestimonial(); // Re-open Add Testimonial
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
        title: 'Testimonials',
        showBack: Navigator.canPop(context),
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search by peer name, city, company...',
        onSearchTap: () {
          setState(() => _isSearching = true);
        },
        onSearchChanged: (query) {
          context.read<TestimonialsBloc>().add(TestimonialsSearchChanged(query));
        },
        onSearchClose: () {
          _searchController.clear();
          context.read<TestimonialsBloc>().add(const TestimonialsSearchChanged(''));
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
          child: BlocConsumer<TestimonialsBloc, TestimonialsState>(
            listener: (context, state) {
              if (state.currentStatus == TestimonialsStatus.failure &&
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
                    child: TestimonialsBottomNav(
                      activeTab: activeTab,
                      onTabChanged: (tab) {
                        context.read<TestimonialsBloc>().add(
                              TestimonialsTabChanged(tab),
                            );
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 34,
                    child: Center(
                      child: AddTestimonialFab(
                        onTap: _openAddTestimonial,
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
    required TestimonialTab activeTab,
    required TestimonialsStatus status,
    required List list,
    required String searchQuery,
  }) {
    if (status == TestimonialsStatus.loading && list.isEmpty) {
      return const TestimonialSkeletonList();
    }

    if (status == TestimonialsStatus.failure && list.isEmpty) {
      return TestimonialErrorView(
        onRetry: () {
          if (activeTab == TestimonialTab.received) {
            context.read<TestimonialsBloc>().add(
                  const TestimonialsFetchReceivedRequested(forceRefresh: true),
                );
          } else {
            context.read<TestimonialsBloc>().add(
                  const TestimonialsFetchGivenRequested(forceRefresh: true),
                );
          }
        },
      );
    }

    if (list.isEmpty) {
      return TestimonialEmptyState(
        tab: activeTab,
        searchQuery: searchQuery,
        onActionTap: _openAddTestimonial,
      );
    }

    return TestimonialListView(
      testimonials: list.cast(),
      tabType: activeTab == TestimonialTab.received ? 'received' : 'given',
      scrollController: _scrollController,
      isLoadingMore: context.select<TestimonialsBloc, bool>(
        (b) => b.state.isLoadingMore,
      ),
      onRefresh: () async {
        if (activeTab == TestimonialTab.received) {
          context.read<TestimonialsBloc>().add(
                const TestimonialsFetchReceivedRequested(forceRefresh: true),
              );
        } else {
          context.read<TestimonialsBloc>().add(
                const TestimonialsFetchGivenRequested(forceRefresh: true),
              );
        }
      },
    );
  }
}
