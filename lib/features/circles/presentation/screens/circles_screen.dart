import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/circles_bloc.dart';
import '../bloc/circles_event.dart';
import '../bloc/circles_state.dart';
import '../widgets/circles_skeleton_loader.dart';
import '../widgets/circles_tab_bar.dart';
import '../widgets/join_circle_view.dart';
import '../widgets/my_circles_view.dart';

class CirclesScreen extends StatefulWidget {
  const CirclesScreen({super.key});

  @override
  State<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends State<CirclesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CirclesBloc>();
    if (bloc.state.status == CirclesStatus.initial) {
      bloc.add(const CirclesFetchRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async {
            context.read<CirclesBloc>().add(const CirclesRefreshRequested());
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                  child: CirclesTabBar(
                    activeTab: state.activeTab,
                    myCirclesCount: state.myCircles.length,
                    onTabSelected: (tab) {
                      context.read<CirclesBloc>().add(CirclesTabChanged(tab));
                    },
                  ),
                ),
              ),
              if (state.status == CirclesStatus.loading &&
                  state.myCircles.isEmpty &&
                  state.categories.isEmpty)
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
              else
                JoinCircleView(
                  industryCategories: state.industryCategories,
                  interestCategories: state.interestCategories,
                  onCategoryTap: (category) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.circleJoin,
                      arguments: {
                        'circleId': category.id.toString(),
                        'defaultSectorName': category.name,
                        'defaultSectorId': category.id,
                      },
                    );
                  },
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
              ),
            ],
          ),
        );
      },
    );
  }
}
