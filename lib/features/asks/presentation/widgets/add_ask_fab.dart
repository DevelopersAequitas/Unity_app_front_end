import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class AddAskFab extends StatelessWidget {
  final VoidCallback onTap;

  const AddAskFab({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        gradient: AppColor.brandGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryPink.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'Post Ask',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
