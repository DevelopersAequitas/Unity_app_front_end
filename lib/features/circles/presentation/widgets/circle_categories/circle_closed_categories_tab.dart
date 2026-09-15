import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../domain/entities/circle_closed_category_entity.dart';
import '../../../domain/entities/flat_open_category_item.dart';
import 'circle_closed_category_card.dart';

class CircleClosedCategoriesTab extends StatelessWidget {
  final List<CircleClosedCategoryEntity> closedFiltered;
  final List<FlatOpenCategoryItem> openFiltered;
  final String query;
  final VoidCallback onRefresh;
  final VoidCallback onSwitchToOpen;

  const CircleClosedCategoriesTab({
    super.key,
    required this.closedFiltered,
    required this.openFiltered,
    required this.query,
    required this.onRefresh,
    required this.onSwitchToOpen,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    if (closedFiltered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 32,
                color: secondaryText.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 8),
              Text(
                query.isEmpty
                    ? 'No closed categories in this circle'
                    : 'No closed categories match "$query"',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              if (query.isNotEmpty && openFiltered.isNotEmpty) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: onSwitchToOpen,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.primaryBlue.withValues(alpha: 0.15)
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? AppColor.primaryBlue.withValues(alpha: 0.3)
                            : const Color(0xFFDBEAFE),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Found ${openFiltered.length} matching in Open',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: AppColor.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final profileState = context.watch<ProfileBloc>().state;
    final authState = context.watch<AuthBloc>().state;
    final currentUserId = profileState.profile?.id ?? authState.user?.id;

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 2, bottom: 16),
        itemCount: closedFiltered.length,
        itemBuilder: (context, index) {
          final item = closedFiltered[index];
          return CircleClosedCategoryCard(
            item: item,
            currentUserId: currentUserId,
          );
        },
      ),
    );
  }
}
