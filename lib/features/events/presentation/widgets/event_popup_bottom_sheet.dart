import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color.dart';
import '../../../menu/presentation/screens/circular_detail_screen.dart';
import '../../../menu/presentation/screens/circulars_screen.dart';
import '../../data/models/event_popup_model.dart';
import '../screens/events_screen.dart';

class EventPopupBottomSheet extends StatefulWidget {
  final EventPopupModel popup;
  final VoidCallback onClose;

  const EventPopupBottomSheet({
    super.key,
    required this.popup,
    required this.onClose,
  });

  @override
  State<EventPopupBottomSheet> createState() => _EventPopupBottomSheetState();
}

class _EventPopupBottomSheetState extends State<EventPopupBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final List<_ConfettiConfig> _confettiList = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeIn),
      ),
    );

    // Initialize random confetti configs
    for (int i = 0; i < 20; i++) {
      _confettiList.add(
        _ConfettiConfig(
          angle: _random.nextDouble() * 2 * math.pi,
          distance: 70.0 + _random.nextDouble() * 90.0,
          size: 5.0 + _random.nextDouble() * 8.0,
          color: _getRandomColor(),
          isCircle: _random.nextBool(),
          rotationSpeed: 0.4 + _random.nextDouble() * 1.2,
        ),
      );
    }

    _animController.forward();
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFF2E93), // Vivid Pink
      const Color(0xFFFFD700), // Gold
      const Color(0xFF00E5FF), // Cyan
      const Color(0xFF10B981), // Emerald Green
      Colors.white,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  String _formatEventDateTime(String? startStr) {
    if (startStr == null || startStr.trim().isEmpty) return '';
    try {
      final parts = startStr.trim().split(' ');
      if (parts.length < 2) return startStr;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final monthName = months[month - 1];

      final isAm = hour < 12;
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final displayMinute = minute.toString().padLeft(2, '0');
      final period = isAm ? 'AM' : 'PM';

      return '$day $monthName $year  ·  $displayHour:$displayMinute $period';
    } catch (_) {
      return startStr;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final popup = widget.popup;
    final formattedTime = _formatEventDateTime(popup.startDatetime);

    return Container(
      width: double.infinity,
      height: mediaQuery.size.height,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background Gradient Overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                widget.onClose();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF001F4D).withValues(alpha: 0.0),
                      const Color(0xFF001F4D).withValues(alpha: 0.88),
                      const Color(0xFF000D20),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Content Layout
          SafeArea(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Column(
                  children: [
                    const Spacer(),

                    // Close Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onClose();
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Center Image Mockup Card with Confetti
                    if (popup.imageUrl != null &&
                        popup.imageUrl!.trim().isNotEmpty &&
                        popup.imageUrl!.trim().startsWith('http')) ...[
                      Center(
                        child: SizedBox(
                          width: 280,
                          height: 210,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              // Confetti particles radiating
                              ..._confettiList.map((confetti) {
                                final currentDist =
                                    confetti.distance * _scaleAnimation.value;
                                final radX =
                                    140.0 + math.cos(confetti.angle) * currentDist;
                                final radY =
                                    105.0 + math.sin(confetti.angle) * currentDist;

                                return Positioned(
                                  left: radX,
                                  top: radY,
                                  child: Opacity(
                                    opacity: _opacityAnimation.value,
                                    child: Transform.rotate(
                                      angle: confetti.rotationSpeed *
                                          _animController.value *
                                          2 *
                                          math.pi,
                                      child: Container(
                                        width: confetti.size,
                                        height: confetti.size,
                                        decoration: BoxDecoration(
                                          color: confetti.color,
                                          shape: confetti.isCircle
                                              ? BoxShape.circle
                                              : BoxShape.rectangle,
                                          borderRadius: confetti.isCircle
                                              ? null
                                              : BorderRadius.circular(1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              // White Mockup Card
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  width: 240,
                                  height: 135,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.35),
                                        blurRadius: 28,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: popup.imageUrl!.trim(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.shade100,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColor.primaryBlue,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Details Block
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          // Event Title
                          Text(
                            popup.eventName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Event Date & Time
                          if (formattedTime.isNotEmpty) ...[
                            Text(
                              formattedTime,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          // Description
                          if (popup.popupMessage.isNotEmpty)
                            Text(
                              popup.popupMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.5,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CTA Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              widget.onClose();

                              if (popup.eventType == 'Circular') {
                                if (popup.eventId.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CircularDetailScreen(
                                        circularId: popup.eventId,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CircularsScreen(),
                                    ),
                                  );
                                }
                              } else if (popup.eventType == 'Ad') {
                                final url = popup.popupActionUrl;
                                if (url != null && url.isNotEmpty) {
                                  try {
                                    final uri = Uri.parse(url);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint(
                                      '[EventPopupBottomSheet] Error launching ad URL: $e',
                                    );
                                  }
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EventsScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColor.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 4,
                              shadowColor: AppColor.primaryBlue.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            child: Text(
                              popup.eventType == 'Circular'
                                  ? 'View Circular'
                                  : (popup.eventType == 'Ad'
                                      ? 'Learn More'
                                      : 'Book Seat Now'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiConfig {
  final double angle;
  final double distance;
  final double size;
  final Color color;
  final bool isCircle;
  final double rotationSpeed;

  _ConfettiConfig({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
    required this.isCircle,
    required this.rotationSpeed,
  });
}
