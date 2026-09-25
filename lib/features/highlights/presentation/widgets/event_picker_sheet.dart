import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/event_item_entity.dart';

class EventPickerSheet extends StatefulWidget {
  final List<EventItemEntity> events;
  final String? selectedEventId;
  final bool isLoading;

  const EventPickerSheet({
    super.key,
    required this.events,
    this.selectedEventId,
    this.isLoading = false,
  });

  static Future<EventItemEntity?> show({
    required BuildContext context,
    required List<EventItemEntity> events,
    String? selectedEventId,
    bool isLoading = false,
  }) {
    return showModalBottomSheet<EventItemEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EventPickerSheet(
        events: events,
        selectedEventId: selectedEventId,
        isLoading: isLoading,
      ),
    );
  }

  @override
  State<EventPickerSheet> createState() => _EventPickerSheetState();
}

class _EventPickerSheetState extends State<EventPickerSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final now = DateTime.now().subtract(const Duration(hours: 6));
    final filtered = widget.events.where((e) {
      final parsedDate = DateTime.tryParse(e.startAt) ?? DateTime.tryParse(e.startDate);
      if (parsedDate != null && parsedDate.isBefore(now)) {
        return false;
      }
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final titleMatch = e.title.toLowerCase().contains(q);
      final circleMatch = e.circleName?.toLowerCase().contains(q) ?? false;
      final locMatch = e.locationText?.toLowerCase().contains(q) ?? false;
      return titleMatch || circleMatch || locMatch;
    }).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: secondaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Upcoming Event', style: AppTypography.titleMedium.copyWith(color: textColor, fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (widget.events.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search event by name or circle...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    filled: true,
                    fillColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Expanded(
              child: widget.isLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            widget.events.isEmpty ? 'No upcoming events found' : 'No matching events',
                            style: AppTypography.bodySmall.copyWith(color: secondaryColor),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final event = filtered[index];
                            final isSelected = widget.selectedEventId == event.id || widget.selectedEventId == event.occurrenceId;
                            return _buildEventTile(context, event, isSelected, isDark, textColor, secondaryColor);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, EventItemEntity event, bool isSelected, bool isDark, Color textColor, Color secondaryColor) {
    return InkWell(
      onTap: () => Navigator.pop(context, event),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryBlue.withValues(alpha: 0.08)
              : (isDark ? AppColor.darkBackground : AppColor.lightBackground),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryBlue : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
            width: isSelected ? 1.5 : 0.6,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildModeBadge(event),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (event.circleName != null && event.circleName!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event.circleName!,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: secondaryColor),
                    const SizedBox(width: 4),
                    Text(
                      event.displayDate.isNotEmpty ? event.displayDate : event.startDate,
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: secondaryColor),
                    ),
                  ],
                ),
                if (event.displayTime.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded, size: 12, color: secondaryColor),
                      const SizedBox(width: 4),
                      Text(
                        event.displayTime,
                        style: AppTypography.bodySmall.copyWith(fontSize: 11, color: secondaryColor),
                      ),
                    ],
                  ),
              ],
            ),
            if (event.locationText != null && event.locationText!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(event.isOnline ? Icons.videocam_outlined : Icons.location_on_outlined, size: 13, color: secondaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.locationText!,
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: secondaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModeBadge(EventItemEntity event) {
    final isOnline = event.isOnline;
    final color = isOnline ? const Color(0xFF10B981) : AppColor.primaryBlue;
    final text = isOnline ? 'Online Meet' : 'Physical Event';
    final icon = isOnline ? Icons.videocam_outlined : Icons.location_on_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.labelSmall.copyWith(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
