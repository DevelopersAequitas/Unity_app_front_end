import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/circle_entity.dart';
import '../widgets/circle_detail/circle_detail_about.dart';
import '../widgets/circle_detail/circle_detail_focus_areas.dart';
import '../widgets/circle_detail/circle_detail_header.dart';
import '../widgets/circle_detail/circle_detail_leadership.dart';
import '../widgets/circle_detail/circle_detail_meeting_cards.dart';
import '../widgets/circle_detail/circle_detail_peers_preview.dart';

class CircleDetailScreen extends StatelessWidget {
  final CircleEntity? circle;

  const CircleDetailScreen({super.key, this.circle});

  @override
  Widget build(BuildContext context) {
    if (circle == null) {
      return Scaffold(
        appBar: AppCommonBar(
          title: 'Circle Details',
          showBack: true,
          showSearch: false,
          showNotifications: false,
          showProfile: false,
          onBackTap: () => Navigator.of(context).pop(),
        ),
        body: const Center(child: Text('Circle details not found')),
      );
    }

    final entity = circle!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: entity.name,
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, size: 20, color: iconColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, size: 22, color: iconColor),
            onPressed: () {},
          ),
        ],
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                CircleDetailHeader(circle: entity),
                const SizedBox(height: 14),
                CircleDetailAbout(circle: entity),
                const SizedBox(height: 14),
                CircleDetailFocusAreas(circle: entity),
                const SizedBox(height: 14),
                CircleDetailLeadership(circle: entity),
                const SizedBox(height: 14),
                CircleDetailPeersPreview(circle: entity),
                const SizedBox(height: 14),
                CircleDetailMeetingCards(circle: entity),
                SizedBox(height: 32 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
