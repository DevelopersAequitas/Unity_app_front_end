import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class MenuSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const MenuSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColor.lightTextSecondary,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              final isLast = index == children.length - 1;
              return Column(
                children: [
                  children[index],
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColor.lightSurfaceSubtle,
                      indent: 56,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
