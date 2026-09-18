import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/usecases/get_given_testimonials_usecase.dart';
import '../../domain/usecases/get_received_testimonials_usecase.dart';
import '../../domain/usecases/get_user_testimonials_usecase.dart';
import '../bloc/testimonials_bloc.dart';
import '../bloc/testimonials_event.dart';
import '../bloc/testimonials_state.dart';
import '../widgets/testimonial_card.dart';
import '../widgets/testimonial_empty_state.dart';
import '../widgets/testimonial_error_view.dart';
import '../widgets/testimonial_skeleton_list.dart';

class PeerTestimonialsScreen extends StatelessWidget {
  final String peerId;
  final String peerName;

  const PeerTestimonialsScreen({
    super.key,
    required this.peerId,
    this.peerName = 'Peer',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => TestimonialsBloc(
        getReceivedTestimonialsUseCase:
            ctx.read<GetReceivedTestimonialsUseCase>(),
        getGivenTestimonialsUseCase: ctx.read<GetGivenTestimonialsUseCase>(),
        getUserTestimonialsUseCase: ctx.read<GetUserTestimonialsUseCase>(),
      )..add(TestimonialsFetchUserRequested(peerId)),
      child: _PeerTestimonialsView(peerId: peerId, peerName: peerName),
    );
  }
}

class _PeerTestimonialsView extends StatefulWidget {
  final String peerId;
  final String peerName;

  const _PeerTestimonialsView({
    required this.peerId,
    required this.peerName,
  });

  @override
  State<_PeerTestimonialsView> createState() => _PeerTestimonialsViewState();
}

class _PeerTestimonialsViewState extends State<_PeerTestimonialsView> {
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
      context
          .read<TestimonialsBloc>()
          .add(TestimonialsLoadMoreUserRequested(widget.peerId));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.peerName.isNotEmpty && widget.peerName != 'Peer'
        ? '${widget.peerName.toUpperCase()}\'S TESTIMONIALS'
        : 'TESTIMONIALS';

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: title,
        showBack: true,
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search by peer name, city, company...',
        onSearchTap: () {
          setState(() => _isSearching = true);
        },
        onSearchChanged: (query) {
          context
              .read<TestimonialsBloc>()
              .add(TestimonialsSearchChanged(query));
        },
        onSearchClose: () {
          _searchController.clear();
          context
              .read<TestimonialsBloc>()
              .add(const TestimonialsSearchChanged(''));
          setState(() => _isSearching = false);
        },
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.pop(context),
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveContainer(
          child: BlocConsumer<TestimonialsBloc, TestimonialsState>(
            listener: (context, state) {
              if (state.receivedStatus == TestimonialsStatus.failure &&
                  state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final status = state.receivedStatus;
              final list = state.filteredUserTestimonials;

              if (status == TestimonialsStatus.loading &&
                  state.userTestimonials.isEmpty) {
                return const TestimonialSkeletonList();
              }

              if (status == TestimonialsStatus.failure &&
                  state.userTestimonials.isEmpty) {
                return TestimonialErrorView(
                  onRetry: () {
                    context.read<TestimonialsBloc>().add(
                          TestimonialsFetchUserRequested(widget.peerId),
                        );
                  },
                );
              }

              if (list.isEmpty) {
                return TestimonialEmptyState(
                  tab: TestimonialTab.received,
                  searchQuery: state.searchQuery,
                );
              }

              final extraItem = state.isLoadingMore ? 1 : 0;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TestimonialsBloc>().add(
                        TestimonialsFetchUserRequested(widget.peerId),
                      );
                },
                color: AppColor.primaryBlue,
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
                      return TestimonialCard(
                        testimonial: item,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
