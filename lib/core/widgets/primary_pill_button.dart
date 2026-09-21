import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class PrimaryPillButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool? showArrow;
  final double width;
  final double height;
  final Widget? icon;
  final IconData? iconData;
  final double? iconSize;
  final bool isOutlined;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const PrimaryPillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.showArrow,
    this.width = double.infinity,
    this.height = 50.0,
    this.icon,
    this.iconData,
    this.iconSize,
    this.isOutlined = false,
    this.gradient,
    this.textStyle,
    this.borderRadius,
    this.padding,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool displayArrow =
        widget.showArrow ?? (widget.icon == null && widget.iconData == null);
    final double radius =
        widget.borderRadius?.topLeft.x ?? (widget.height / 2);
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(radius);
    final double defaultIconSize = widget.height < 45 ? 17.0 : 20.0;
    final double effectiveIconSize = widget.iconSize ?? defaultIconSize;

    final Gradient effectiveGradient = widget.gradient ??
        const LinearGradient(
          colors: [
            Color(0xFF1D4ED8),
            Color(0xFF3B82F6),
            Color(0xFFE11D48),
            Color(0xFFF43F5E),
          ],
          stops: [0.0, 0.35, 0.75, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );

    final Gradient disabledGradient = LinearGradient(
      colors: [
        AppColor.primaryBlue.withValues(alpha: 0.3),
        AppColor.primaryPink.withValues(alpha: 0.3),
      ],
    );

    final TextStyle defaultStyle = (widget.height < 45
            ? AppTypography.titleSmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )
            : AppTypography.titleMedium)
        .copyWith(
      color: Colors.white,
    );

    final effectiveTextStyle = widget.textStyle ?? defaultStyle;

    Widget buttonContent;
    if (widget.isLoading) {
      buttonContent = SizedBox(
        width: effectiveIconSize,
        height: effectiveIconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.isOutlined ? AppColor.primaryBlue : AppColor.white,
          ),
        ),
      );
    } else {
      final innerRow = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: 6),
          ] else if (widget.iconData != null) ...[
            Icon(
              widget.iconData,
              size: effectiveIconSize,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              widget.label,
              style: effectiveTextStyle.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (displayArrow) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              size: effectiveIconSize,
              color: Colors.white,
            ),
          ],
        ],
      );

      if (widget.isOutlined) {
        buttonContent = isEnabled
            ? ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => effectiveGradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: innerRow,
              )
            : Opacity(
                opacity: 0.5,
                child: innerRow,
              );
      } else {
        buttonContent = innerRow;
      }
    }

    Widget containerBody;
    if (widget.isOutlined) {
      const double borderWidth = 1.3;
      final double innerRadius = (radius - borderWidth).clamp(0.0, 999.0);

      containerBody = Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          gradient: isEnabled ? effectiveGradient : disabledGradient,
          borderRadius: effectiveBorderRadius,
          boxShadow: isEnabled && !_isPressed
              ? [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(innerRadius),
          ),
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: widget.height < 45 ? 12 : 16,
              ),
          alignment: Alignment.center,
          child: buttonContent,
        ),
      );
    } else {
      containerBody = Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: isEnabled ? effectiveGradient : disabledGradient,
          borderRadius: effectiveBorderRadius,
          border: Border.all(
            color: AppColor.white.withValues(alpha: 0.3),
            width: 1.0,
          ),
          boxShadow: isEnabled && !_isPressed
              ? [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.28),
                    blurRadius: widget.height < 45 ? 8 : 16,
                    offset: Offset(
                      widget.height < 45 ? -2 : -4,
                      widget.height < 45 ? 4 : 8,
                    ),
                  ),
                  BoxShadow(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.28),
                    blurRadius: widget.height < 45 ? 8 : 16,
                    offset: Offset(
                      widget.height < 45 ? 2 : 4,
                      widget.height < 45 ? 4 : 8,
                    ),
                  ),
                ]
              : null,
        ),
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: widget.height < 45 ? 12 : 16,
            ),
        alignment: Alignment.center,
        child: buttonContent,
      );
    }

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: isEnabled ? widget.onPressed : null,
          behavior: HitTestBehavior.opaque,
          child: containerBody,
        ),
      ),
    );
  }
}
