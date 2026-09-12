import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class PrimaryPillButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool showArrow;
  final double width;

  const PrimaryPillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.showArrow = true,
    this.width = double.infinity,
  });

  @override
  State<PrimaryPillButton> createState() => _PrimaryPillButtonState();
}

class _PrimaryPillButtonState extends State<PrimaryPillButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isPressed) setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (_isPressed) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: widget.width,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF1D4ED8),
                        Color(0xFF3B82F6),
                        Color(0xFFE11D48),
                        Color(0xFFF43F5E),
                      ],
                      stops: [0.0, 0.35, 0.75, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : LinearGradient(
                      colors: [
                        AppColor.primaryBlue.withValues(alpha: 0.4),
                        AppColor.primaryPink.withValues(alpha: 0.4),
                      ],
                    ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColor.white.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: isEnabled && !_isPressed
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1D4ED8).withValues(alpha: 0.32),
                        blurRadius: 16,
                        offset: const Offset(-4, 8),
                      ),
                      BoxShadow(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.32),
                        blurRadius: 16,
                        offset: const Offset(4, 8),
                      ),
                    ]
                  : null,
            ),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: isEnabled ? widget.onPressed : null,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColor.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                          if (widget.showArrow) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: AppColor.white,
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
