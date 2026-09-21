import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/post_ask/post_ask_bloc.dart';
import '../bloc/post_ask/post_ask_event.dart';
import '../bloc/post_ask/post_ask_state.dart';
import '../widgets/highlight_segmented_tab_bar.dart';
import '../widgets/my_asks_list_view.dart';
import '../widgets/post_ask_form_tab.dart';

class PostAskScreen extends StatefulWidget {
  final int initialTabIndex;
  final String title;

  const PostAskScreen({
    super.key,
    this.initialTabIndex = 0,
    this.title = 'Collaboration Ask',
  });

  @override
  State<PostAskScreen> createState() => _PostAskScreenState();
}

class _PostAskScreenState extends State<PostAskScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
    context.read<PostAskBloc>().add(const FetchMyAsksEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostAskBloc, PostAskState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == PostAskStatus.success || curr.status == PostAskStatus.error),
      listener: (context, state) {
        if (state.status == PostAskStatus.success && state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
        } else if (state.status == PostAskStatus.error && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppCommonBar(
          title: widget.title,
          showBack: Navigator.canPop(context),
          showSearch: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: HighlightSegmentedTabBar(
                    controller: _tabController,
                    tabTitles: const ['Post an Ask', 'My Asks'],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      PostAskFormTab(onSuccess: () => _tabController.animateTo(1)),
                      const MyAsksListView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
