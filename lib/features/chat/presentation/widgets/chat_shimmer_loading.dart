import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class ChatShimmerLoading extends StatelessWidget {
  const ChatShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        final isRight = index % 2 == 1;
        return Align(
          alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: MediaQuery.of(context).size.width * (index % 3 == 0 ? 0.65 : 0.45),
            height: 48,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isRight ? 14 : 4),
                bottomRight: Radius.circular(isRight ? 4 : 14),
              ),
            ),
          ),
        );
      },
    );
  }
}
