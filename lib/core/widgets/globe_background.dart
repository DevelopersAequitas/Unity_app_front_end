import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class GlobeBackground extends StatelessWidget {
  final double bottomOffset;
  final double overlayOpacity;

  const GlobeBackground({
    super.key,
    this.bottomOffset = 80,
    this.overlayOpacity = 0.26,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: AppColor.white,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: -30,
              right: -30,
              bottom: bottomOffset,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/earth.png',
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                  Positioned.fill(
                    child: ColoredBox(
                      color: AppColor.white.withValues(alpha: overlayOpacity),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
