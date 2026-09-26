import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class AskCardHighlightWrapper extends StatefulWidget {
  final Widget child;
  final bool isHighlighted;
  final BorderRadius? borderRadius;

  const AskCardHighlightWrapper({
    super.key,
    required this.child,
    this.isHighlighted = false,
    this.borderRadius,
  });

  @override
  State<AskCardHighlightWrapper> createState() =>
      _AskCardHighlightWrapperState();
}

class _AskCardHighlightWrapperState extends State<AskCardHighlightWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int _completedHalfCycles = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (!mounted) return;
      if (status == AnimationStatus.completed) {
        _completedHalfCycles++;
        if (_completedHalfCycles < 6) {
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        _completedHalfCycles++;
        if (_completedHalfCycles < 6) {
          _controller.forward();
        }
      }
    });

    if (widget.isHighlighted) {
      // Small initial delay so screen is rendered before pulse begins
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted && widget.isHighlighted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant AskCardHighlightWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _completedHalfCycles = 0;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isHighlighted && _completedHalfCycles >= 6) {
      return widget.child;
    }

    final radius = widget.borderRadius ?? BorderRadius.circular(14);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final val = _animation.value;
        if (val <= 0.001) return widget.child;

        return Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryBlue.withValues(alpha: 0.45 * val),
                blurRadius: 14 * val,
                spreadRadius: 2.5 * val,
              ),
            ],
          ),
          child: Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      color: AppColor.primaryBlue.withValues(alpha: 0.1 * val),
                      border: Border.all(
                        color: AppColor.primaryBlue.withValues(alpha: 0.85 * val),
                        width: 1.8 * val,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
