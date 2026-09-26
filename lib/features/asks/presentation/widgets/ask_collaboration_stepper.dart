import 'package:flutter/material.dart';

class CollaborationStepItem {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrent;

  const CollaborationStepItem({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class AskCollaborationStepper extends StatelessWidget {
  final List<CollaborationStepItem> steps;
  final ValueChanged<int>? onStepTap;

  const AskCollaborationStepper({
    super.key,
    required this.steps,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final descColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const activeGreen = Color(0xFF0E7A68);
    final inactiveBorder = isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: InkWell(
            onTap: onStepTap != null ? () => onStepTap!(index) : null,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _buildCircle(step, activeGreen, inactiveBorder),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: step.isCompleted ? activeGreen : inactiveBorder,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          step.description,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: descColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCircle(
    CollaborationStepItem step,
    Color activeGreen,
    Color inactiveBorder,
  ) {
    if (step.isCompleted) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: activeGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 18, color: Colors.white),
      );
    }

    if (step.isCurrent) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: activeGreen, width: 2.2),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: inactiveBorder, width: 2),
      ),
    );
  }
}
