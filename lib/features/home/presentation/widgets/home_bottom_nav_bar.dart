import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onCreateTap;

  const HomeBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final isShorts = selectedIndex == 4;
    final isDark = Theme.of(context).brightness == Brightness.dark || isShorts;
    final bgColor = isShorts ? Colors.black : (isDark ? AppColor.darkSurface : AppColor.lightSurface);
    final borderColor = isShorts ? Colors.white12 : (isDark ? AppColor.darkBorder : AppColor.lightBorder);
    final activeColor = isShorts ? Colors.white : AppColor.primaryBlue;
    final inactiveColor = isShorts
        ? Colors.white60
        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 0.8)),
      ),
      padding: EdgeInsets.zero,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              selectedSvg: 'assets/icons-svg/home-filled.svg',
              unselectedSvg: 'assets/icons-svg/home.svg',
              label: 'Home',
              isSelected: selectedIndex == 0,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(0),
            ),
            _NavItem(
              selectedIcon: Icons.people_rounded,
              unselectedIcon: Icons.people_outline_rounded,
              label: 'Peers',
              isSelected: selectedIndex == 1,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(1),
            ),
            _CenterNavButton(onTap: onCreateTap),
            _NavItem(
              selectedIcon: Icons.bubble_chart_rounded,
              unselectedIcon: Icons.bubble_chart_outlined,
              label: 'Circles',
              isSelected: selectedIndex == 3,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(3),
            ),
            _NavItem(
              selectedIcon: Icons.play_circle_filled_rounded,
              unselectedIcon: Icons.play_circle_outline_rounded,
              label: 'Shorts',
              isSelected: selectedIndex == 4,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => onItemSelected?.call(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterNavButton extends StatefulWidget {
  final VoidCallback? onTap;
  const _CenterNavButton({this.onTap});

  @override
  State<_CenterNavButton> createState() => _CenterNavButtonState();
}

class _CenterNavButtonState extends State<_CenterNavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: -0.04,
      end: 0.04,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Transform.translate(
      offset: const Offset(0, -22),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColor.brandGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryBlue.withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 12,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColor.primaryPink.withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/icon-bg.png',
                      width: 42,
                      height: 42,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? selectedIcon;
  final IconData? unselectedIcon;
  final String? selectedSvg;
  final String? unselectedSvg;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    this.selectedIcon,
    this.unselectedIcon,
    this.selectedSvg,
    this.unselectedSvg,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  Widget _buildIcon(Color color) {
    if (selectedSvg != null && unselectedSvg != null) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: isSelected
            ? ShaderMask(
                key: const ValueKey('selected_gradient_svg'),
                shaderCallback: (bounds) =>
                    AppColor.brandGradient.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: SvgPicture.asset(
                  selectedSvg!,
                  width: 22,
                  height: 22,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : SvgPicture.asset(
                unselectedSvg!,
                key: const ValueKey('unselected_svg'),
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
      );
    }

    return AnimatedScale(
      scale: isSelected ? 1.15 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: isSelected
          ? ShaderMask(
              shaderCallback: (bounds) =>
                  AppColor.brandGradient.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: Icon(
                selectedIcon ?? Icons.circle,
                size: 22,
                color: Colors.white,
              ),
            )
          : Icon(
              unselectedIcon ?? Icons.circle_outlined,
              size: 22,
              color: color,
            ),
    );
  }

  Widget _buildLabel(Color color) {
    if (isSelected) {
      return ShaderMask(
        shaderCallback: (bounds) =>
            AppColor.brandGradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white,
            fontSize: 10,
            height: 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Text(
      label,
      style: AppTypography.labelSmall.copyWith(
        color: color,
        fontSize: 10,
        height: 1.1,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? activeColor : inactiveColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: SizedBox(
          width: 58,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(color),
              const SizedBox(height: 1),
              _buildLabel(color),
            ],
          ),
        ),
      ),
    );
  }
}
