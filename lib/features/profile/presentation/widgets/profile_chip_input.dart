import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileChipInput extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final String hintText;
  final Color accentColor;
  final List<String>? suggestions;

  const ProfileChipInput({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.hintText = 'Add item',
    this.accentColor = AppColor.primary,
    this.suggestions,
  });

  static final Map<String, List<String>> _defaultSuggestions = {
    'Business Keywords / Tags': [
      'SaaS',
      'Artificial Intelligence',
      'Mobile App Development',
      'Web Development',
      'Digital Marketing',
      'E-commerce',
      'Cloud Solutions',
      'Cybersecurity',
      'FinTech',
      'EdTech',
      'HealthTech',
      'B2B Sales',
      'Consulting',
      'UI/UX Design',
      'Supply Chain',
      'Logistics',
      'Real Estate',
      'Manufacturing',
      'Import / Export',
      'Legal Services',
      'Accounting & Tax',
    ],
    'General Interests': [
      'Technology & AI',
      'Entrepreneurship',
      'Networking',
      'Startups & Investing',
      'Sustainability & Green Tech',
      'Leadership',
      'Marketing & Branding',
      'Product Design',
      'Public Speaking',
      'Reading & Learning',
      'Fitness & Wellness',
      'Travel & Culture',
    ],
    'I Can Help With': [
      'Business Strategy',
      'Tech Consultation',
      'Pitching & Fundraising',
      'Mentorship',
      'Marketing Strategy',
      'Hiring & Talent',
      'Product Development',
      'Legal & Compliance',
      'Financial Modeling',
      'Client Acquisition',
      'Strategic Partnerships',
    ],
    'I Am Looking For': [
      'Co-Founders',
      'Angel Investors / VC',
      'Tech Talent',
      'B2B Clients',
      'Channel Partners',
      'Mentors & Advisors',
      'Marketing Specialists',
      'International Expansion',
      'Suppliers & Vendors',
      'Industry Collaborations',
    ],
    'Industries of Interest': [
      'Information Technology',
      'Healthcare & Life Sciences',
      'Fintech & Banking',
      'E-commerce & Retail',
      'Clean Energy & Cleantech',
      'Real Estate & PropTech',
      'Education & EdTech',
      'Manufacturing & Industrial',
      'Agriculture & AgriTech',
      'Media & Entertainment',
      'Food & Beverage',
      'Logistics & Supply Chain',
    ],
    'Collaboration Goals': [
      'Joint Ventures',
      'Co-Marketing & Promotion',
      'Referral Sharing',
      'Strategic Partnerships',
      'Knowledge Exchange',
      'Product Integration',
      'Vendor Collaboration',
      'Community Initiatives',
    ],
    'Sustainability Areas': [
      'Clean & Renewable Energy',
      'Waste Reduction & Recycling',
      'Sustainable Packaging',
      'Carbon Footprint Reduction',
      'Water Conservation',
      'Eco-Friendly Products',
      'Circular Economy',
      'Green Supply Chain',
      'ESG Compliance',
    ],
    'Skills & Expertise': [
      'Project Management',
      'Business Strategy',
      'Product Strategy',
      'Flutter & Mobile Apps',
      'Full Stack Web Dev',
      'Cloud Architecture (AWS / GCP / Azure)',
      'Data Analytics & ML',
      'DevOps & CI/CD',
      'UI/UX & Product Design',
      'Digital Marketing & SEO',
      'Sales & Negotiation',
      'Financial Analysis & Budgeting',
      'Operations Management',
      'Legal & Compliance',
      'Brand Building & PR',
      'Public Speaking & Pitching',
      'Agile & Scrum Leadership',
      'Cybersecurity & Auditing',
      'Content Creation & Copywriting',
      'Customer Success & Retention',
    ],
    'Leadership Roles': [
      'Founder / Co-Founder',
      'Chief Executive Officer (CEO)',
      'Chief Technology Officer (CTO)',
      'Chief Operating Officer (COO)',
      'Chief Marketing Officer (CMO)',
      'Chief Financial Officer (CFO)',
      'Managing Director',
      'Vice President (VP)',
      'Head of Engineering',
      'Head of Product',
      'Head of Growth / Marketing',
      'Head of Sales',
      'Board Member / Director',
      'Chapter President',
      'Community Lead',
      'Startup Mentor / Advisor',
      'Team Lead / Engineering Manager',
      'Committee Chair',
    ],
    'Special Recognitions & Awards': [
      'Speaker of the Year',
      'Top Entrepreneur Award',
      'Innovator of the Year',
      'Best Startup Founder Award',
      'Industry Excellence Award',
      'Forbes 30 Under 30 / 40 Under 40',
      'Outstanding Leadership Award',
      'Community Contributor of the Year',
      'Published Author / Thought Leader',
      'Patents / IP Holder',
      'National / State Level Recognition',
      'Hackathon Winner / Finalist',
      'Distinguished Alumni Award',
      'Excellence in Innovation Award',
    ],
  };

  List<String> _getEffectiveSuggestions() {
    if (suggestions != null && suggestions!.isNotEmpty) {
      return suggestions!;
    }

    if (_defaultSuggestions.containsKey(label)) {
      return _defaultSuggestions[label]!;
    }

    final cleanLabel = label.toLowerCase();
    for (final entry in _defaultSuggestions.entries) {
      final key = entry.key.toLowerCase();
      if (key == cleanLabel ||
          cleanLabel.contains(key) ||
          key.contains(cleanLabel)) {
        return entry.value;
      }
    }

    if (cleanLabel.contains('skill')) {
      return _defaultSuggestions['Skills & Expertise']!;
    }
    if (cleanLabel.contains('leader')) {
      return _defaultSuggestions['Leadership Roles']!;
    }
    if (cleanLabel.contains('award') || cleanLabel.contains('recogni')) {
      return _defaultSuggestions['Special Recognitions & Awards']!;
    }
    if (cleanLabel.contains('keyword') || cleanLabel.contains('tag')) {
      return _defaultSuggestions['Business Keywords / Tags']!;
    }
    if (cleanLabel.contains('interest')) {
      return _defaultSuggestions['General Interests']!;
    }
    if (cleanLabel.contains('help')) {
      return _defaultSuggestions['I Can Help With']!;
    }
    if (cleanLabel.contains('look') || cleanLabel.contains('seeking')) {
      return _defaultSuggestions['I Am Looking For']!;
    }
    if (cleanLabel.contains('industry')) {
      return _defaultSuggestions['Industries of Interest']!;
    }
    if (cleanLabel.contains('goal') || cleanLabel.contains('collab')) {
      return _defaultSuggestions['Collaboration Goals']!;
    }
    if (cleanLabel.contains('sustain') || cleanLabel.contains('green')) {
      return _defaultSuggestions['Sustainability Areas']!;
    }

    return [];
  }

  void _showSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return _ChipSelectorBottomSheet(
          label: label,
          initialItems: items,
          suggestions: _getEffectiveSuggestions(),
          hintText: hintText,
          accentColor: accentColor,
          onApply: (updated) {
            onChanged(updated);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => _showSelectionBottomSheet(context),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, size: 16, color: accentColor),
                    const SizedBox(width: 2),
                    Text(
                      'Add',
                      style: AppTypography.labelSmall.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColor.backgroundSubtle,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColor.borderSubtle),
          ),
          constraints: const BoxConstraints(minHeight: 48),
          child: items.isEmpty
              ? GestureDetector(
                  onTap: () => _showSelectionBottomSheet(context),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Tap "+ Add" to choose or add $label',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.textTertiary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: items.map((item) {
                    return Container(
                      padding: const EdgeInsets.only(left: 8, right: 4, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              final updated = List<String>.from(items)..remove(item);
                              onChanged(updated);
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: accentColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _ChipSelectorBottomSheet extends StatefulWidget {
  final String label;
  final List<String> initialItems;
  final List<String> suggestions;
  final String hintText;
  final Color accentColor;
  final ValueChanged<List<String>> onApply;

  const _ChipSelectorBottomSheet({
    required this.label,
    required this.initialItems,
    required this.suggestions,
    required this.hintText,
    required this.accentColor,
    required this.onApply,
  });

  @override
  State<_ChipSelectorBottomSheet> createState() => _ChipSelectorBottomSheetState();
}

class _ChipSelectorBottomSheetState extends State<_ChipSelectorBottomSheet> {
  late final TextEditingController _customInputController;
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _customInputController = TextEditingController();
    _selectedItems = List<String>.from(widget.initialItems);
  }

  @override
  void dispose() {
    _customInputController.dispose();
    super.dispose();
  }

  void _addCustomItem() {
    final text = _customInputController.text.trim();
    if (text.isNotEmpty) {
      if (!_selectedItems.any((item) => item.toLowerCase() == text.toLowerCase())) {
        setState(() {
          _selectedItems.add(text);
          _customInputController.clear();
        });
      } else {
        _customInputController.clear();
      }
    }
  }

  void _toggleSuggestion(String suggestion) {
    setState(() {
      final existingIndex = _selectedItems.indexWhere(
        (item) => item.toLowerCase() == suggestion.toLowerCase(),
      );
      if (existingIndex >= 0) {
        _selectedItems.removeAt(existingIndex);
      } else {
        _selectedItems.add(suggestion);
      }
    });
  }

  void _removeItem(String item) {
    setState(() {
      _selectedItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select ${widget.label}',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pick from common suggestions or add your own',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: AppColor.lightTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: AppColor.lightTextSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColor.lightBorder),

          // Content
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom input field
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.lightScaffoldBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColor.lightBorder),
                          ),
                          child: TextField(
                            controller: _customInputController,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColor.lightTextPrimary,
                              fontSize: 12.5,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.hintText,
                              hintStyle: AppTypography.bodySmall.copyWith(
                                color: AppColor.lightTextTertiary,
                                fontSize: 12,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _addCustomItem(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: widget.accentColor,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: _addCustomItem,
                          borderRadius: BorderRadius.circular(10),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_rounded, color: Colors.white, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Selected items section
                  if (_selectedItems.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected (${_selectedItems.length})',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.lightTextPrimary,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedItems.clear()),
                          child: Text(
                            'Clear all',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: widget.accentColor.withValues(alpha: 0.18)),
                      ),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _selectedItems.map((item) {
                          return Container(
                            padding: const EdgeInsets.only(left: 10, right: 6, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: widget.accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                              border: Border.all(color: widget.accentColor.withValues(alpha: 0.35)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: widget.accentColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => _removeItem(item),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 15,
                                    color: widget.accentColor.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Common suggestions section
                  if (widget.suggestions.isNotEmpty) ...[
                    Text(
                      'Popular Suggestions',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 8,
                      children: widget.suggestions.map((suggestion) {
                        final isSelected = _selectedItems.any(
                          (item) => item.toLowerCase() == suggestion.toLowerCase(),
                        );

                        return Material(
                          color: isSelected
                              ? widget.accentColor
                              : AppColor.lightScaffoldBg,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                          child: InkWell(
                            onTap: () => _toggleSuggestion(suggestion),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                                border: Border.all(
                                  color: isSelected
                                      ? widget.accentColor
                                      : AppColor.lightBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.check_rounded
                                        : Icons.add_rounded,
                                    size: 13,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColor.lightTextSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    suggestion,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColor.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom CTA
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              color: AppColor.lightSurface,
              border: Border(top: BorderSide(color: AppColor.lightBorder)),
            ),
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColor.brandGradient,
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryPink.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.onApply(_selectedItems);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(23),
                  child: Center(
                    child: Text(
                      'Apply Selection (${_selectedItems.length})',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
