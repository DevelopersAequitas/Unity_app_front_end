import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class PeersSectionHeader extends StatelessWidget {
  final String title;
  final String selectedSort;
  final VoidCallback onSortTap;

  const PeersSectionHeader({
    super.key,
    this.title = 'ALL PEERS',
    this.selectedSort = 'Most Recent',
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColor.lightTextPrimary,
            ),
          ),
          InkWell(
            onTap: onSortTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    size: 15,
                    color: AppColor.lightTextSecondary,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    selectedSort,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.lightTextSecondary,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 15,
                    color: AppColor.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
