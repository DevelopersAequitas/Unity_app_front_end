import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class AddCollaborationFab extends StatelessWidget {
  final VoidCallback onTap;

  const AddCollaborationFab({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppColor.brandGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryPink.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              size: 26,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
