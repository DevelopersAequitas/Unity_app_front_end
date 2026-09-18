import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'leaderboard_podium_card.dart';

class LeaderboardPodiumSection extends StatelessWidget {
  final List<LeaderboardEntryEntity> topThree;
  final bool isImpact;

  const LeaderboardPodiumSection({
    super.key,
    required this.topThree,
    this.isImpact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) return const SizedBox.shrink();

    final rank1 =
        topThree.where((e) => e.rank == 1).firstOrNull ??
        (topThree.isNotEmpty ? topThree[0] : null);
    final rank2 =
        topThree.where((e) => e.rank == 2).firstOrNull ??
        (topThree.length > 1 ? topThree[1] : null);
    final rank3 =
        topThree.where((e) => e.rank == 3).firstOrNull ??
        (topThree.length > 2 ? topThree[2] : null);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalW = constraints.maxWidth;
          const padH = 10.0;
          final usableW = totalW - (padH * 2);

          // Proportional width calculation matching flex ratios (10 : 11 : 10)
          final sideCardW = (usableW - 12) * (10.0 / 31.0);
          final centerCardW = (usableW - 12) * (11.0 / 31.0);

          final leftX = padH;
          final centerX = padH + sideCardW + 6.0;

          return SizedBox(
            height: 260.0, // Center card height
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // ── 0. Continuous Diffused Ambient Stage Backlight ──
                Positioned.fill(
                  top: 24,
                  bottom: 4,
                  child: const CustomPaint(
                    painter: _PodiumBackstageGlowPainter(),
                  ),
                ),

                // ── 1. Left Card (#2 Silver Stage - Under Center) ──
                if (rank2 != null)
                  Positioned(
                    left: leftX,
                    width: sideCardW,
                    bottom: 0,
                    child: LeaderboardPodiumCard(
                      entry: rank2,
                      rank: 2,
                      isCenter: false,
                      isImpact: isImpact,
                    ),
                  ),

                // ── 2. Right Card (#3 Bronze Stage - Under Center) ──
                if (rank3 != null)
                  Positioned(
                    right: padH,
                    width: sideCardW,
                    bottom: 0,
                    child: LeaderboardPodiumCard(
                      entry: rank3,
                      rank: 3,
                      isCenter: false,
                      isImpact: isImpact,
                    ),
                  ),

                // ── 3. Center Card (#1 Gold Stage - ON TOP in Foreground) ──
                if (rank1 != null)
                  Positioned(
                    left: centerX,
                    width: centerCardW,
                    bottom: 0,
                    child: LeaderboardPodiumCard(
                      entry: rank1,
                      rank: 1,
                      isCenter: true,
                      isImpact: isImpact,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Continuous diffused ambient backlight spanning seamlessly behind the podium stages
class _PodiumBackstageGlowPainter extends CustomPainter {
  const _PodiumBackstageGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // A single continuous smooth ambient backlight band strictly behind the stages
    final rect = Rect.fromLTWH(16, 12, w - 32, h - 20);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0x2E38BDF8), // Distinct cyan/ice under left stage
          Color(0x3860A5FA), // Distinct sky/blue under center stage
          Color(0x2EF472B6), // Distinct rose/pink under right stage
          // Color(0x1838BDF8), // Soft cyan/ice under left stage
          // Color(0x1E60A5FA), // Soft sky/blue under center stage
          // Color(0x18F472B6), // Soft rose/pink under right stage
        ],
        stops: [0.15, 0.50, 0.85],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24.0);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
