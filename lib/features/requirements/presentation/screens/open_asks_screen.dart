import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/requirements_bloc.dart';
import '../bloc/requirements_event.dart';
import '../bloc/requirements_state.dart';
import '../widgets/add_ask_fab.dart';
import '../widgets/asks_bottom_nav.dart';
import '../widgets/requirement_card.dart';
import 'post_ask_form_screen.dart';

class OpenAsksScreen extends StatefulWidget {
  final int initialTabIndex;

  const OpenAsksScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<OpenAsksScreen> createState() => _OpenAsksScreenState();
}

class _OpenAsksScreenState extends State<OpenAsksScreen> {
  late AskTab _activeTab;
  String _searchQuery = '';
  String _selectedStatusFilter = 'all'; // 'all', 'open', 'completed'

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex == 1 ? AskTab.myAsks : AskTab.openAsks;

    final bloc = context.read<RequirementsBloc>();
    bloc.add(const FetchOpenRequirementsEvent());
    bloc.add(const FetchMyRequirementsEvent());
  }

  void _onRefreshOpen() {
    context.read<RequirementsBloc>().add(const FetchOpenRequirementsEvent());
  }

  void _onRefreshMy() {
    context.read<RequirementsBloc>().add(const FetchMyRequirementsEvent());
  }

  void _openPostAskForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostAskFormScreen()),
    ).then((val) {
      if (val == true && mounted) {
        setState(() => _activeTab = AskTab.myAsks);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<RequirementsBloc, RequirementsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == RequirementsStatus.success ||
              curr.status == RequirementsStatus.error),
      listener: (context, state) {
        if (state.status == RequirementsStatus.success &&
            state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
        } else if (state.status == RequirementsStatus.error &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppCommonBar(
          title: 'Open Asks',
          showBack: Navigator.canPop(context),
          showSearch: true,
          showNotifications: false,
          showProfile: true,
          onSearchChanged: (query) {
            setState(() => _searchQuery = query.toLowerCase().trim());
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AddAskFab(onTap: _openPostAskForm),
        bottomNavigationBar: AsksBottomNav(
          activeTab: _activeTab,
          onTabChanged: (tab) => setState(() => _activeTab = tab),
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: Column(
              children: [
                _buildStatusFilterRow(isDark),
                Expanded(
                  child: _activeTab == AskTab.openAsks
                      ? _buildOpenAsksTab(isDark)
                      : _buildMyAsksTab(isDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilterRow(bool isDark) {
    final filters = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Open', 'value': 'open'},
      {'label': 'Completed', 'value': 'completed'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedStatusFilter == filter['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedStatusFilter = filter['value']!),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColor.primaryBlue.withValues(alpha: 0.25) : AppColor.primaryBlue.withValues(alpha: 0.12))
                        : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.primaryBlue
                          : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                      width: isSelected ? 1.2 : 0.8,
                    ),
                  ),
                  child: Text(
                    filter['label']!,
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected
                          ? AppColor.primaryBlue
                          : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOpenAsksTab(bool isDark) {
    return BlocBuilder<RequirementsBloc, RequirementsState>(
      builder: (context, state) {
        if (state.status == RequirementsStatus.loading &&
            state.openRequirements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        var list = state.openRequirements;

        if (_selectedStatusFilter == 'open') {
          list = list.where((r) => r.isOpen).toList();
        } else if (_selectedStatusFilter == 'completed') {
          list = list.where((r) => !r.isOpen).toList();
        }

        if (_searchQuery.isNotEmpty) {
          list = list.where((r) {
            final subject = r.subject.toLowerCase();
            final desc = r.description.toLowerCase();
            final category = (r.category ?? '').toLowerCase();
            final city = (r.cityName ?? '').toLowerCase();
            final author = (r.user?.fullName ?? '').toLowerCase();
            final company = (r.user?.company ?? '').toLowerCase();
            return subject.contains(_searchQuery) ||
                desc.contains(_searchQuery) ||
                category.contains(_searchQuery) ||
                city.contains(_searchQuery) ||
                author.contains(_searchQuery) ||
                company.contains(_searchQuery);
          }).toList();
        }

        if (list.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _onRefreshOpen(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 56,
                        color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No open asks found',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Open asks from peers will appear here. Tap "+" below to post an ask.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _onRefreshOpen(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 4, bottom: 80),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final req = list[index];
              return RequirementCard(
                requirement: req,
                isOwner: false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyAsksTab(bool isDark) {
    return BlocBuilder<RequirementsBloc, RequirementsState>(
      builder: (context, state) {
        if (state.status == RequirementsStatus.loading &&
            state.myRequirements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        var list = state.myRequirements;

        if (_selectedStatusFilter == 'open') {
          list = list.where((r) => r.isOpen).toList();
        } else if (_selectedStatusFilter == 'completed') {
          list = list.where((r) => !r.isOpen).toList();
        }

        if (_searchQuery.isNotEmpty) {
          list = list.where((r) {
            final subject = r.subject.toLowerCase();
            final desc = r.description.toLowerCase();
            final category = (r.category ?? '').toLowerCase();
            final city = (r.cityName ?? '').toLowerCase();
            return subject.contains(_searchQuery) ||
                desc.contains(_searchQuery) ||
                category.contains(_searchQuery) ||
                city.contains(_searchQuery);
          }).toList();
        }

        if (list.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => _onRefreshMy(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 56,
                        color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You haven\'t posted any asks yet',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Tap the "+" button below to post your first business ask.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _onRefreshMy(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 4, bottom: 80),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final req = list[index];
              return RequirementCard(
                requirement: req,
                isOwner: true,
                onComplete: req.isOpen
                    ? () {
                        context
                            .read<RequirementsBloc>()
                            .add(CompleteRequirementEvent(req.id));
                      }
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}
