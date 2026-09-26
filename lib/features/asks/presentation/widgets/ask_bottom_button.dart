import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class AskBottomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AskBottomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 0.9,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 42,
          child: Container(
            decoration: BoxDecoration(
              gradient: (onPressed != null && !isLoading)
                  ? AppColor.brandGradient
                  : null,
              color: (onPressed == null || isLoading)
                  ? (isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle)
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.transparent,
                disabledForegroundColor:
                    isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
