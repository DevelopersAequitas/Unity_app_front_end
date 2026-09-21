import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/event_registration_entity.dart';

Path buildTicketPath(
  Size size, {
  double cornerRadius = 24.0,
  double notchTop = 75.0,
  double notchHeight = 56.0,
  double notchDepth = 10.0,
  double curveRadius = 10.0,
  double lowerNotchFromBottom = 138.0,
  double lowerNotchRadius = 12.0,
}) {
  final path = Path();
  final r = cornerRadius;
  final cr = curveRadius;
  final nd = notchDepth;
  final nt = notchTop;
  final nh = notchHeight;
  final lny = size.height - lowerNotchFromBottom;
  final lnr = lowerNotchRadius;

  // 1. Top-left corner to top-right
  path.moveTo(r, 0);
  path.lineTo(size.width - r, 0);
  path.arcToPoint(Offset(size.width, r), radius: Radius.circular(r));

  // 2. Right edge down to upper QR notch
  path.lineTo(size.width, nt);

  // Inward curve on right
  path.arcToPoint(
    Offset(size.width - nd, nt + cr),
    radius: Radius.circular(cr),
    clockwise: false,
  );

  // Straight recessed vertical line on right
  path.lineTo(size.width - nd, nt + nh - cr);

  // Outward curve on right
  path.arcToPoint(
    Offset(size.width, nt + nh),
    radius: Radius.circular(cr),
    clockwise: false,
  );

  // 3. Right edge down to lower perforated cutout notch
  if (lny - lnr > nt + nh) {
    path.lineTo(size.width, lny - lnr);
    path.arcToPoint(
      Offset(size.width, lny + lnr),
      radius: Radius.circular(lnr),
      clockwise: false,
    );
  }

  // 4. Continue down right edge to bottom-right corner
  path.lineTo(size.width, size.height - r);
  path.arcToPoint(
    Offset(size.width - r, size.height),
    radius: Radius.circular(r),
  );

  // 5. Bottom edge to bottom-left corner
  path.lineTo(r, size.height);
  path.arcToPoint(Offset(0, size.height - r), radius: Radius.circular(r));

  // 6. Left edge up to lower perforated cutout notch
  if (lny - lnr > nt + nh) {
    path.lineTo(0, lny + lnr);
    path.arcToPoint(
      Offset(0, lny - lnr),
      radius: Radius.circular(lnr),
      clockwise: false,
    );
  }

  // 7. Left edge up to bottom of upper QR notch
  path.lineTo(0, nt + nh);

  // Inward curve on left
  path.arcToPoint(
    Offset(nd, nt + nh - cr),
    radius: Radius.circular(cr),
    clockwise: false,
  );

  // Straight recessed vertical line on left
  path.lineTo(nd, nt + cr);

  // Outward curve on left
  path.arcToPoint(Offset(0, nt), radius: Radius.circular(cr), clockwise: false);

  // 8. Continue up left edge to top-left corner
  path.lineTo(0, r);
  path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

  path.close();
  return path;
}

class TicketCardClipper extends CustomClipper<Path> {
  final double notchTop;
  final double notchHeight;
  final double notchDepth;
  final double curveRadius;
  final double cornerRadius;
  final double lowerNotchFromBottom;
  final double lowerNotchRadius;

  TicketCardClipper({
    this.notchTop = 75.0,
    this.notchHeight = 56.0,
    this.notchDepth = 10.0,
    this.curveRadius = 10.0,
    this.cornerRadius = 24.0,
    this.lowerNotchFromBottom = 138.0,
    this.lowerNotchRadius = 12.0,
  });

  @override
  Path getClip(Size size) {
    return buildTicketPath(
      size,
      cornerRadius: cornerRadius,
      notchTop: notchTop,
      notchHeight: notchHeight,
      notchDepth: notchDepth,
      curveRadius: curveRadius,
      lowerNotchFromBottom: lowerNotchFromBottom,
      lowerNotchRadius: lowerNotchRadius,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TicketCardBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color shadowColor;
  final Color dashedLineColor;
  final double notchTop;
  final double notchHeight;
  final double notchDepth;
  final double curveRadius;
  final double cornerRadius;
  final double lowerNotchFromBottom;
  final double lowerNotchRadius;

  TicketCardBorderPainter({
    required this.borderColor,
    required this.shadowColor,
    required this.dashedLineColor,
    this.notchTop = 75.0,
    this.notchHeight = 56.0,
    this.notchDepth = 10.0,
    this.curveRadius = 10.0,
    this.cornerRadius = 24.0,
    this.lowerNotchFromBottom = 138.0,
    this.lowerNotchRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = buildTicketPath(
      size,
      cornerRadius: cornerRadius,
      notchTop: notchTop,
      notchHeight: notchHeight,
      notchDepth: notchDepth,
      curveRadius: curveRadius,
      lowerNotchFromBottom: lowerNotchFromBottom,
      lowerNotchRadius: lowerNotchRadius,
    );

    // Draw shadow
    canvas.drawShadow(path, shadowColor, 12, true);

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);

    // Draw perforated dashed line EXACTLY at center of the lower notch (lny)
    final lny = size.height - lowerNotchFromBottom;
    final lnr = lowerNotchRadius;
    final dashPaint = Paint()
      ..color = dashedLineColor
      ..strokeWidth = 1.2;

    double startX = lnr + 4.0;
    final endX = size.width - lnr - 4.0;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    while (startX < endX) {
      final currentDashEnd = startX + dashWidth;
      canvas.drawLine(
        Offset(startX, lny),
        Offset(currentDashEnd > endX ? endX : currentDashEnd, lny),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    this.color = const Color(0xFFE2E8F0),
    this.dashWidth = 6,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EventQrCard extends StatelessWidget {
  final EventRegistrationEntity ticket;

  const EventQrCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = context.read<ProfileBloc>().state.profile;

    final rawToken = ticket.qrToken?.trim();
    final rawUrl = ticket.qrCodeUrl?.trim();
    final rawRegId = ticket.registrationId.trim();
    final rawOccId = ticket.occurrenceId?.trim();

    final isImageUrl =
        rawUrl != null &&
        (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) &&
        (rawUrl.endsWith('.png') ||
            rawUrl.endsWith('.jpg') ||
            rawUrl.endsWith('.jpeg') ||
            rawUrl.contains('event-qrcodes') ||
            rawUrl.contains('/files/'));

    final qrData = (rawToken != null && rawToken.isNotEmpty)
        ? rawToken
        : ((rawUrl != null && rawUrl.isNotEmpty && !isImageUrl)
              ? rawUrl
              : (rawRegId.isNotEmpty
                    ? rawRegId
                    : (rawOccId != null && rawOccId.isNotEmpty
                          ? rawOccId
                          : 'PEERS-PASS')));

    final displayTicketId = rawRegId.startsWith('PG-')
        ? rawRegId
        : 'PG-2026-${rawRegId.length > 6 ? rawRegId.substring(0, 6).toUpperCase() : (rawRegId.isNotEmpty ? rawRegId.toUpperCase() : '001234')}';

    final displayRegId = rawRegId.startsWith('REG-')
        ? rawRegId
        : 'REG-2026-${rawRegId.length > 6 ? rawRegId.substring(rawRegId.length - 6).toUpperCase() : (rawRegId.isNotEmpty ? rawRegId.toUpperCase() : '567890')}';

    final attendeeName =
        (ticket.attendeeName != null && ticket.attendeeName!.trim().isNotEmpty)
        ? ticket.attendeeName!.trim()
        : (profile?.displayName.isNotEmpty == true
              ? profile!.displayName
              : ((profile?.firstName != null && profile!.firstName!.isNotEmpty)
                    ? '${profile.firstName} ${profile.lastName ?? ""}'.trim()
                    : 'Attendee'));

    final attendeeCompany =
        (ticket.attendeeCompany != null &&
            ticket.attendeeCompany!.trim().isNotEmpty)
        ? ticket.attendeeCompany!.trim()
        : (profile?.companyName ??
              profile?.designation ??
              'Peers Global Member');

    final dateStr = ticket.startAt != null
        ? AppDateFormatter.format(ticket.startAt)
        : '01 Oct 2026';

    String timeStr;
    if (ticket.startAt != null) {
      final sTime = AppDateFormatter.formatTime(ticket.startAt);
      if (ticket.endAt != null) {
        final eTime = AppDateFormatter.formatTime(ticket.endAt);
        timeStr = '$sTime - $eTime';
      } else {
        timeStr = sTime;
      }
    } else {
      timeStr = '9:00 AM - 6:00 PM';
    }

    final venueStr =
        (ticket.location != null && ticket.location!.trim().isNotEmpty)
        ? ticket.location!.trim()
        : 'NSCI Dome, Mumbai';

    String priceStr = 'Free';
    if (ticket.ticketPrice != null && ticket.ticketPrice!.trim().isNotEmpty) {
      final p = double.tryParse(ticket.ticketPrice!);
      if (p != null && p > 0) {
        final cur = (ticket.currency == 'INR' || ticket.currency == null)
            ? '₹'
            : '${ticket.currency} ';
        priceStr =
            '$cur${p.toStringAsFixed(p.truncateToDouble() == p ? 0 : 2)}';
      }
    }

    final cardBgColor = isDark ? AppColor.darkSurface : Colors.white;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : const Color(0xFF64748B);
    final borderColor = isDark ? AppColor.darkBorder : const Color(0xFFE2E8F0);
    final shadowColor = const Color(
      0xFF64748B,
    ).withValues(alpha: isDark ? 0.25 : 0.12);

    final dashedLineColor = isDark ? AppColor.darkBorder : const Color(0xFFCBD5E1);

    return CustomPaint(
      painter: TicketCardBorderPainter(
        borderColor: borderColor,
        shadowColor: shadowColor,
        dashedLineColor: dashedLineColor,
        notchTop: 75.0,
        notchHeight: 56.0,
        notchDepth: 10.0,
        curveRadius: 10.0,
        cornerRadius: 24.0,
        lowerNotchFromBottom: 138.0,
        lowerNotchRadius: 12.0,
      ),
      child: ClipPath(
        clipper: TicketCardClipper(
          notchTop: 75.0,
          notchHeight: 56.0,
          notchDepth: 10.0,
          curveRadius: 10.0,
          cornerRadius: 24.0,
          lowerNotchFromBottom: 138.0,
          lowerNotchRadius: 12.0,
        ),
        child: Container(
          color: cardBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ================= UPPER SECTION =================
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Direct Compressed QR Code
                    Center(
                      child: isImageUrl
                          ? CachedNetworkImage(
                              imageUrl: rawUrl,
                              width: 185,
                              height: 185,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const SizedBox(
                                width: 185,
                                height: 185,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 185,
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 185,
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Event Title & Subtitle
                    Text(
                      ticket.eventTitle ?? 'Global Business Summit 2026',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'General Admission',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Meta Rows
                    _buildMetaRow(
                      icon: Icons.calendar_today_outlined,
                      content: Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    _buildMetaRow(
                      icon: Icons.access_time_rounded,
                      content: Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    _buildMetaRow(
                      icon: Icons.location_on_outlined,
                      content: Text(
                        venueStr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    _buildMetaRow(
                      icon: Icons.person_outline_rounded,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attendeeName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            attendeeCompany,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ================= LOWER SECTION (RECEIPT TABLE) =================
              SizedBox(
                height: 138.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTableItem(
                        'Ticket ID',
                        displayTicketId,
                        isDark,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                      _buildTableItem(
                        'Registration ID',
                        displayRegId,
                        isDark,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: secondaryTextColor,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Confirmed',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _buildTableItem(
                        'Ticket Price',
                        priceStr,
                        isDark,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow({required IconData icon, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildTableItem(
    String label,
    String value,
    bool isDark,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: secondaryColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
