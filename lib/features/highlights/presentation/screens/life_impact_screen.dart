import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/life_impact/life_impact_bloc.dart';
import '../bloc/life_impact/life_impact_event.dart';
import '../bloc/life_impact/life_impact_state.dart';
import '../widgets/add_impact_tab.dart';
import '../widgets/life_impact_bottom_nav.dart';
import '../widgets/life_impact_score_tab.dart';

class LifeImpactScreen extends StatefulWidget {
  final int initialTabIndex;

  const LifeImpactScreen({super.key, this.initialTabIndex = 0});

  @override
  State<LifeImpactScreen> createState() => _LifeImpactScreenState();
}

class _LifeImpactScreenState extends State<LifeImpactScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && mounted) {
        setState(() => _currentIndex = _tabController.index);
      }
    });

    final bloc = context.read<LifeImpactBloc>();
    bloc.add(const FetchLifeImpactHistoryEvent());
    bloc.add(const FetchLifeImpactActionsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Life Impact',
        showBack: Navigator.canPop(context),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      bottomNavigationBar: LifeImpactBottomNav(
        activeIndex: _currentIndex,
        onIndexChanged: (idx) {
          setState(() => _currentIndex = idx);
          _tabController.animateTo(idx);
        },
      ),
      body: AppGradientBackground(
        child: BlocConsumer<LifeImpactBloc, LifeImpactState>(
          listenWhen: (prev, curr) =>
              (curr.successMessage != null && prev.successMessage != curr.successMessage) ||
              (curr.errorMessage != null && prev.errorMessage != curr.errorMessage),
          listener: (context, state) {
            if (state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
              _tabController.animateTo(0);
            } else if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                LifeImpactScoreTab(state: state),
                AddImpactTab(
                  state: state,
                  onSubmit: (params) {
                    context.read<LifeImpactBloc>().add(SubmitLifeImpactEvent(params));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
