import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/recommend_peer/recommend_peer_bloc.dart';
import '../bloc/recommend_peer/recommend_peer_event.dart';
import '../bloc/recommend_peer/recommend_peer_state.dart';
import '../widgets/recommend_peer_history_list.dart';

class RecommendPeerHistoryScreen extends StatefulWidget {
  const RecommendPeerHistoryScreen({super.key});

  @override
  State<RecommendPeerHistoryScreen> createState() =>
      _RecommendPeerHistoryScreenState();
}

class _RecommendPeerHistoryScreenState
    extends State<RecommendPeerHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<RecommendPeerBloc>()
        .add(const FetchPeerRecommendationsHistoryEvent());
  }

  Future<void> _onRefresh() async {
    context
        .read<RecommendPeerBloc>()
        .add(const RefreshPeerRecommendationsHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Past Recommendations',
        showBack: Navigator.canPop(context),
        onBackTap:
            Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<RecommendPeerBloc, RecommendPeerState>(
            builder: (context, state) {
              return RecommendPeerHistoryList(
                history: state.history,
                isLoading:
                    state.historyStatus == RecommendPeerHistoryStatus.loading,
                onRefresh: _onRefresh,
              );
            },
          ),
        ),
      ),
    );
  }
}
