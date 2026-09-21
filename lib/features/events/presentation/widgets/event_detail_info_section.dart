import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/event_entity.dart';

class EventDetailInfoSection extends StatefulWidget {
  final EventEntity event;

  const EventDetailInfoSection({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailInfoSection> createState() => _EventDetailInfoSectionState();
}

class _EventDetailInfoSectionState extends State<EventDetailInfoSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final event = widget.event;

    final primary = isDark ? AppColor.darkTextPrimary : const Color(0xFF1E293B);
    final secondary = isDark ? AppColor.darkTextSecondary : const Color(0xFF64748B);
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final dividerColor = isDark ? AppColor.darkBorder : const Color(0xFFE2E8F0);

    // ── Date/time: prefer server-formatted display_time (correct tz) ──
    final dateStr = event.displayDate?.isNotEmpty == true
        ? event.displayDate
        : (event.startAt != null ? AppDateFormatter.format(event.startAt) : null);

    final timeStr = event.displayTime?.isNotEmpty == true
        ? event.displayTime
        : (() {
            if (event.startAt == null) return null;
            final s = AppDateFormatter.formatTime(event.startAt);
            final e = event.endAt != null ? ' - ${AppDateFormatter.formatTime(event.endAt)}' : '';
            return '$s$e';
          })();

    // ── Venue ──
    final venueStr = (event.location?.trim().isNotEmpty == true) ? event.location!.trim() : null;

    // ── Attendees (only real data) ──
    final attendeeStr = event.registeredCount > 0
        ? '${event.registeredCount}+ Registered'
        : null;

    // ── Description ──
    final description = event.description.trim().isNotEmpty ? event.description.trim() : null;

    // ── Speakers ──
    final speakers = event.speakers.where((s) => s['name']?.isNotEmpty == true).toList();

    // ── Agenda ──
    final agenda = event.agendaItems.where((a) => a['title']?.isNotEmpty == true).toList();

    // ── What you'll gain ──
    final gains = event.whatYoullGain.where((g) => g.trim().isNotEmpty).toList();

    // ── Organizer ──
    final organizerName = (event.organizerName?.trim().isNotEmpty == true &&
            event.organizerName!.toLowerCase() != 'null')
        ? event.organizerName
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ──
        Text(
          event.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primary, height: 1.2),
        ),

        // ── Description ──
        if (description != null) ...[
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: secondary, height: 1.5),
            ),
            secondChild: Text(
              description,
              style: TextStyle(fontSize: 13, color: secondary, height: 1.5),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Read Less' : 'Read More',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: const Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 14),

        // ── Info card (date / venue / attendees) ──
        if (dateStr != null || venueStr != null || attendeeStr != null)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: dividerColor),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                if (dateStr != null)
                  _infoRow(
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFF4A6FA5),
                    iconBg: const Color(0xFFEEF2FF),
                    title: dateStr,
                    subtitle: timeStr,
                    primary: primary,
                    secondary: secondary,
                  ),
                if (dateStr != null && venueStr != null)
                  Divider(height: 1, indent: 16, endIndent: 16, color: dividerColor),
                if (venueStr != null)
                  _infoRow(
                    icon: Icons.location_on_outlined,
                    iconColor: const Color(0xFFE11D48),
                    iconBg: const Color(0xFFFFF1F3),
                    title: venueStr,
                    subtitle: 'Venue Location',
                    primary: primary,
                    secondary: secondary,
                  ),
                if (venueStr != null && attendeeStr != null)
                  Divider(height: 1, indent: 16, endIndent: 16, color: dividerColor),
                if (attendeeStr != null)
                  _infoRow(
                    icon: Icons.people_alt_outlined,
                    iconColor: const Color(0xFF059669),
                    iconBg: const Color(0xFFECFDF5),
                    title: attendeeStr,
                    subtitle: 'Registered Members',
                    primary: primary,
                    secondary: secondary,
                  ),
              ],
            ),
          ),

        // ── What you'll gain ──
        if (gains.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionLabel('What You\'ll Gain', primary),
          const SizedBox(height: 8),
          ...gains.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF059669)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(g, style: TextStyle(fontSize: 13, color: secondary, height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],

        // ── Agenda ──
        if (agenda.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionLabel('Agenda', primary),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: dividerColor),
            ),
            child: Column(
              children: agenda.asMap().entries.map((entry) {
                final isLast = entry.key == agenda.length - 1;
                final item = entry.value;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            alignment: Alignment.centerRight,
                            child: Text(
                              item['time'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(width: 2, height: 32, color: const Color(0xFF2563EB).withValues(alpha: 0.2)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['title'] ?? '',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast) Divider(height: 1, indent: 82, color: dividerColor),
                  ],
                );
              }).toList(),
            ),
          ),
        ],

        // ── Speakers ──
        if (speakers.isNotEmpty) ...[
          const SizedBox(height: 16),
          _sectionLabel('Speakers', primary),
          const SizedBox(height: 8),
          ...speakers.map((s) => _buildSpeakerRow(s, primary, secondary, cardBg, dividerColor)),
        ],

        // ── Organizer (if different from circle name) ──
        if (organizerName != null) ...[
          const SizedBox(height: 16),
          _sectionLabel('Organizer', primary),
          const SizedBox(height: 6),
          Text(organizerName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primary)),
        ],
      ],
    );
  }

  Widget _sectionLabel(String label, Color primary) {
    return Text(
      label,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primary),
    );
  }

  Widget _buildSpeakerRow(
    Map<String, String> s,
    Color primary,
    Color secondary,
    Color cardBg,
    Color borderColor,
  ) {
    final name = s['name'] ?? '';
    final designation = s['designation'] ?? '';
    final company = s['company'] ?? '';
    final photoUrl = s['photo_url'] ?? '';
    final initials = s['initials'] ?? (name.isNotEmpty ? name[0].toUpperCase() : '?');
    final subtitle = [designation, company].where((x) => x.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF2563EB),
              backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
              child: photoUrl.isEmpty
                  ? Text(initials, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: primary)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: TextStyle(fontSize: 11, color: secondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    String? subtitle,
    required Color primary,
    required Color secondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: primary, height: 1.3)),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: secondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
