import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'highlight_text_field.dart';

import '../../../../core/utils/app_date_formatter.dart';

class RegisterVisitorFormFields extends StatelessWidget {
  final TextEditingController eventNameController;
  final TextEditingController visitorFullNameController;
  final TextEditingController visitorMobileController;
  final TextEditingController visitorEmailController;
  final TextEditingController visitorCityController;
  final TextEditingController visitorBusinessController;
  final TextEditingController noteController;
  final String eventType;
  final ValueChanged<String> onEventTypeChanged;
  final DateTime? eventDate;
  final VoidCallback onPickDate;
  final VoidCallback onPickEvent;
  final VoidCallback onPickCity;
  final String howKnown;
  final ValueChanged<String> onHowKnownChanged;
  final VoidCallback? onPickContact;

  const RegisterVisitorFormFields({
    super.key,
    required this.eventNameController,
    required this.visitorFullNameController,
    required this.visitorMobileController,
    required this.visitorEmailController,
    required this.visitorCityController,
    required this.visitorBusinessController,
    required this.noteController,
    required this.eventType,
    required this.onEventTypeChanged,
    required this.eventDate,
    required this.onPickDate,
    required this.onPickEvent,
    required this.onPickCity,
    required this.howKnown,
    required this.onHowKnownChanged,
    this.onPickContact,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = eventDate != null
        ? AppDateFormatter.format(eventDate)
        : 'Select Event Date *';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _buildTypeOption(context, 'physical', 'Physical Event', Icons.location_on_outlined)),
            const SizedBox(width: 8),
            Expanded(child: _buildTypeOption(context, 'online', 'Online Meet', Icons.videocam_outlined)),
          ],
        ),
        const SizedBox(height: 10),
        HighlightTextField(
          controller: eventNameController,
          label: 'Event Name *',
          hint: 'Tap to select upcoming event',
          readOnly: true,
          onTap: onPickEvent,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Please select an event' : null,
          suffixIcon: IconButton(
            icon: const Icon(Icons.event_available_outlined, color: AppColor.primaryBlue, size: 20),
            tooltip: 'Choose from upcoming events',
            onPressed: onPickEvent,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onPickDate,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.bodyMedium.copyWith(
                    color: eventDate != null
                        ? (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary)
                        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                  ),
                ),
                Icon(Icons.calendar_today_rounded, size: 16, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        HighlightTextField(
          controller: visitorFullNameController,
          label: 'Visitor Full Name *',
          hint: 'Enter full name',
          suffixIcon: onPickContact != null
              ? IconButton(
                  icon: const Icon(Icons.contacts_outlined, color: AppColor.primaryBlue, size: 20),
                  tooltip: 'Pick from contacts',
                  onPressed: onPickContact,
                )
              : null,
        ),
        const SizedBox(height: 10),
        HighlightTextField(
          controller: visitorMobileController,
          label: 'Visitor Mobile Number *',
          hint: '10-digit mobile number',
          keyboardType: TextInputType.phone,
          suffixIcon: onPickContact != null
              ? IconButton(
                  icon: const Icon(Icons.perm_contact_calendar_outlined, color: AppColor.primaryBlue, size: 20),
                  tooltip: 'Pick from contacts',
                  onPressed: onPickContact,
                )
              : null,
        ),
        const SizedBox(height: 10),
        HighlightTextField(
          controller: visitorEmailController,
          label: 'Visitor Email',
          hint: 'email@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        _buildHowKnownDropdown(context, isDark),
        const SizedBox(height: 10),
        HighlightTextField(
          controller: visitorCityController,
          label: 'Visitor City *',
          hint: 'Select or enter city',
          onTap: onPickCity,
          suffixIcon: IconButton(
            icon: const Icon(Icons.location_city_rounded, color: AppColor.primaryBlue, size: 20),
            tooltip: 'Choose city',
            onPressed: onPickCity,
          ),
        ),
        const SizedBox(height: 10),
        HighlightTextField(
          controller: visitorBusinessController,
          label: 'Business / Profession *',
          hint: 'e.g. Architect, Tech Founder',
        ),
        const SizedBox(height: 10),
        HighlightTextField(controller: noteController, label: 'Remarks / Notes', hint: 'Additional context or introduction notes', maxLines: 2),
      ],
    );
  }

  Widget _buildTypeOption(BuildContext context, String value, String title, IconData icon) {
    final isSelected = eventType == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => onEventTypeChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryBlue.withValues(alpha: 0.1) : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColor.primaryBlue : (isDark ? AppColor.darkBorder : AppColor.lightBorder), width: isSelected ? 1.5 : 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColor.primaryBlue : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary)),
            const SizedBox(width: 6),
            Text(title, style: AppTypography.bodySmall.copyWith(color: isSelected ? AppColor.primaryBlue : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildHowKnownDropdown(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: howKnown,
          isExpanded: true,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          items: const [
            DropdownMenuItem(value: 'friend', child: Text('Friend / Acquaintance')),
            DropdownMenuItem(value: 'business_associate', child: Text('Business Associate')),
            DropdownMenuItem(value: 'client', child: Text('Client / Customer')),
            DropdownMenuItem(value: 'vendor', child: Text('Vendor / Partner')),
            DropdownMenuItem(value: 'relative', child: Text('Family / Relative')),
            DropdownMenuItem(value: 'other', child: Text('Other')),
          ],
          onChanged: (val) => val != null ? onHowKnownChanged(val) : null,
        ),
      ),
    );
  }
}
