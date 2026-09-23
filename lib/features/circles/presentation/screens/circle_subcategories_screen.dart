import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/usecases/get_category_subcategories_usecase.dart';
import '../bloc/circle_subcategories_bloc.dart';
import '../bloc/circle_subcategories_event.dart';
import '../bloc/circle_subcategories_state.dart';
import '../widgets/subcategories/circle_subcategory_bottom_action.dart';
import '../widgets/subcategories/circle_subcategory_other_tile.dart';
import '../widgets/subcategories/circle_subcategory_search_bar.dart';
import '../widgets/subcategories/circle_subcategory_tile.dart';

class CircleSubcategoriesScreen extends StatelessWidget {
  final String circleId;
  final String circleName;
  final bool isPicker;
  final CircleCategoryEntity? initialSelectedCategory;
  final bool initialIsOther;

  const CircleSubcategoriesScreen({
    super.key,
    required this.circleId,
    required this.circleName,
    this.isPicker = false,
    this.initialSelectedCategory,
    this.initialIsOther = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CircleSubcategoriesBloc(
        getCategorySubcategoriesUseCase:
            context.read<GetCategorySubcategoriesUseCase>(),
        initialSelectedCategory: initialSelectedCategory,
        initialIsOther: initialIsOther,
      )..add(CircleSubcategoriesFetchRequested(circleId)),
      child: _CircleSubcategoriesView(
        circleId: circleId,
        circleName: circleName,
        isPicker: isPicker,
      ),
    );
  }
}

class _CircleSubcategoriesView extends StatefulWidget {
  final String circleId;
  final String circleName;
  final bool isPicker;

  const _CircleSubcategoriesView({
    required this.circleId,
    required this.circleName,
    required this.isPicker,
  });

  @override
  State<_CircleSubcategoriesView> createState() =>
      _CircleSubcategoriesViewState();
}

class _CircleSubcategoriesViewState extends State<_CircleSubcategoriesView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategoryTapped(
    BuildContext context,
    CircleCategoryEntity? cat,
    bool isOther,
  ) {
    context.read<CircleSubcategoriesBloc>().add(
          CircleSubcategorySelected(subcategory: cat, isOther: isOther),
        );

    if (widget.isPicker) {
      Navigator.of(context).pop({'category': cat, 'isOther': isOther});
    }
  }

  void _onProceed(BuildContext context, CircleSubcategoriesState state) {
    Navigator.pushNamed(
      context,
      AppRoutes.circleJoin,
      arguments: {
        'circleId': widget.circleId,
        'defaultSectorName': widget.circleName,
        'defaultSectorId': widget.circleId,
        'preselectedCategory': state.selectedSubcategory,
        'isOtherCategory': state.isOtherSelected,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Scaffold(
      backgroundColor: AppColor.transparent,
      appBar: AppCommonBar(
        title: widget.circleName,
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<CircleSubcategoriesBloc, CircleSubcategoriesState>(
            builder: (context, state) {
              return Column(
                children: [
                  CircleSubcategorySearchBar(
                    controller: _searchController,
                    onChanged: (q) => context
                        .read<CircleSubcategoriesBloc>()
                        .add(CircleSubcategoriesSearchChanged(q)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          'Choose your specialization / role',
                          style: AppTypography.labelSmall.copyWith(color: secondaryText),
                        ),
                        const Spacer(),
                        if (state.status == CircleSubcategoriesStatus.success)
                          Text(
                            '${state.filteredSubcategories.length} available',
                            style: AppTypography.labelSmall.copyWith(color: AppColor.primaryBlue),
                          ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildBody(context, state)),
                  if (!widget.isPicker)
                    CircleSubcategoryBottomAction(
                      selectedSubcategory: state.selectedSubcategory,
                      isOtherSelected: state.isOtherSelected,
                      onProceed: () => _onProceed(context, state),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CircleSubcategoriesState state) {
    switch (state.status) {
      case CircleSubcategoriesStatus.initial:
      case CircleSubcategoriesStatus.loading:
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
        );
      case CircleSubcategoriesStatus.error:
        return _buildErrorState(context, state.errorMessage);
      case CircleSubcategoriesStatus.success:
        if (state.filteredSubcategories.isEmpty && state.searchQuery.isNotEmpty) {
          return _buildEmptyState(context);
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: state.filteredSubcategories.length + 1,
          itemBuilder: (context, index) {
            if (index == state.filteredSubcategories.length) {
              return CircleSubcategoryOtherTile(
                isSelected: state.isOtherSelected,
                onTap: () => _onCategoryTapped(context, null, true),
              );
            }
            final cat = state.filteredSubcategories[index];
            return CircleSubcategoryTile(
              category: cat,
              isSelected: state.isCatSelected(cat),
              onTap: () => _onCategoryTapped(context, cat, false),
            );
          },
        );
    }
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return AppErrorView(
      title: 'Unable to Load Specializations',
      message: message,
      onRetry: () => context
          .read<CircleSubcategoriesBloc>()
          .add(CircleSubcategoriesFetchRequested(widget.circleId)),
      screenName: 'Circle Categories',
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 40, color: AppColor.lightTextDisabled),
            const SizedBox(height: 12),
            const Text('No specializations found', style: AppTypography.titleMedium),
            const SizedBox(height: 4),
            const Text('Try searching for another keyword or select Other.', style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}
