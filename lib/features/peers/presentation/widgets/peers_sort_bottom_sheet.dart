import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class PeersSortBottomSheet extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortSelected;

  const PeersSortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  static const _options = [
    'Most Recent',
    'Highest Impact',
    'Alphabetical (A-Z)',
    'Alphabetical (Z-A)',
  ];

  static void show(
    BuildContext context, {
    required String selectedSort,
    required ValueChanged<String> onSortSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => PeersSortBottomSheet(
        selectedSort: selectedSort,
        onSortSelected: onSortSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Sort Peers By',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColor.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ..._options.map((option) {
              final isSelected = option == selectedSort;
              return ListTile(
                title: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColor.primaryBlue
                        : AppColor.lightTextPrimary,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColor.primaryBlue, size: 20)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSortSelected(option);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
