import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../domain/entities/ask_form_config_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_choice_chips_group.dart';
import '../widgets/ask_step_header.dart';
import '../widgets/ask_text_input_group.dart';

class AskStep2FiltersScreen extends StatefulWidget {
  final AskSubmissionEntity submission;

  const AskStep2FiltersScreen({
    super.key,
    required this.submission,
  });

  @override
  State<AskStep2FiltersScreen> createState() => _AskStep2FiltersScreenState();
}

class _AskStep2FiltersScreenState extends State<AskStep2FiltersScreen> {
  final Map<String, TextEditingController> _filterTextControllers = {};
  final Map<String, Set<String>> _selectedFilterOptions = {};

  @override
  void initState() {
    super.initState();
    if (widget.submission.industry != null) {
      _selectedFilterOptions['industry'] = {widget.submission.industry!};
    }
    if (widget.submission.geography != null) {
      _selectedFilterOptions['geography'] = {widget.submission.geography!};
    }
    if (widget.submission.businessStage != null) {
      _selectedFilterOptions['business_stage'] = {widget.submission.businessStage!};
    }
    if (widget.submission.timeline != null) {
      _selectedFilterOptions['timeline'] = {widget.submission.timeline!};
    }
    if (widget.submission.expectedOutcome.isNotEmpty) {
      _getController('expected_outcome').text = widget.submission.expectedOutcome;
    }
  }

  @override
  void dispose() {
    for (final ctrl in _filterTextControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String key) {
    return _filterTextControllers.putIfAbsent(key, () => TextEditingController());
  }

  void _onOptionToggled(AskOptionGroupEntity group, String optionCode) {
    setState(() {
      final current = _selectedFilterOptions[group.code] ?? <String>{};
      if (group.isMultiSelect) {
        if (current.contains(optionCode)) {
          current.remove(optionCode);
        } else {
          current.add(optionCode);
        }
      } else {
        current.clear();
        current.add(optionCode);
      }
      _selectedFilterOptions[group.code] = current;
    });
  }

  String _formatFilterLabel(String key) {
    switch (key.toLowerCase()) {
      case 'referral_industry':
      case 'industry':
        return 'Industry';
      case 'referral_geography':
      case 'geography':
        return 'Geography';
      case 'business_stage':
        return 'Business stage';
      case 'timeline':
      case 'help_timing':
        return 'Timeline';
      case 'expected_outcome':
        return 'Expected outcome';
      default:
        return key
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
    }
  }

  bool _canContinue(AskFormConfigEntity config) {
    final isReferral = widget.submission.flow.code.toLowerCase() == 'referral';
    List<String> filterKeys = config.filterSectionKeys;
    if (filterKeys.isEmpty) {
      final detailKeySet = config.detailSectionKeys.toSet();
      filterKeys = config.groups
          .where((g) => !detailKeySet.contains(g.code))
          .map((g) => g.code)
          .toList();
    }
    if (isReferral && filterKeys.isEmpty) {
      filterKeys = ['referral_industry', 'referral_geography'];
    }

    final rendered = <String>{};
    for (final key in filterKeys) {
      if (rendered.contains(key.toLowerCase())) continue;
      rendered.add(key.toLowerCase());

      var group = config.getGroupByCode(key);
      if (group != null && group.isActive && group.options.isNotEmpty) {
        if ((_selectedFilterOptions[group.code] ?? {}).isEmpty) {
          return false;
        }
      } else if (isReferral && (key.contains('industry') || key.contains('geography'))) {
        final selected = _selectedFilterOptions[key] ??
            _selectedFilterOptions[key.replaceAll('referral_', '')] ??
            {};
        if (selected.isEmpty) return false;
      } else {
        final ctrl = _filterTextControllers[key];
        if (ctrl == null || ctrl.text.trim().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _onPreview() {
    final customAnswers = Map<String, dynamic>.from(widget.submission.customAnswers);
    for (final entry in _filterTextControllers.entries) {
      if (entry.value.text.trim().isNotEmpty) {
        customAnswers[entry.key] = entry.value.text.trim();
      }
    }
    for (final entry in _selectedFilterOptions.entries) {
      if (entry.value.isNotEmpty) {
        customAnswers[entry.key] = entry.value.toList();
      }
    }

    final updatedSubmission = widget.submission.copyWith(
      industry: _selectedFilterOptions['industry']?.firstOrNull ??
          _selectedFilterOptions['referral_industry']?.firstOrNull,
      geography: _selectedFilterOptions['geography']?.firstOrNull ??
          _selectedFilterOptions['referral_geography']?.firstOrNull,
      businessStage: _selectedFilterOptions['business_stage']?.firstOrNull,
      timeline: _selectedFilterOptions['timeline']?.firstOrNull ??
          _selectedFilterOptions['help_timing']?.firstOrNull,
      expectedOutcome: _filterTextControllers['expected_outcome']?.text.trim() ?? '',
      customAnswers: customAnswers,
    );

    final isReferral = widget.submission.flow.code.toLowerCase() == 'referral';

    if (isReferral) {
      Navigator.of(context).pushNamed(
        AppRoutes.askReferralReason,
        arguments: updatedSubmission,
      );
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.askPreview,
        arguments: updatedSubmission,
      );
    }
  }

  List<Widget> _buildFilterSections(AskFormConfigEntity config) {
    final widgets = <Widget>[];
    final isReferral = widget.submission.flow.code.toLowerCase() == 'referral';

    List<String> filterKeys = config.filterSectionKeys;
    if (filterKeys.isEmpty) {
      final detailKeySet = config.detailSectionKeys.toSet();
      filterKeys = config.groups
          .where((g) => !detailKeySet.contains(g.code))
          .map((g) => g.code)
          .toList();
    }

    if (isReferral && filterKeys.isEmpty) {
      filterKeys = ['referral_industry', 'referral_geography'];
    }

    final rendered = <String>{};

    for (final key in filterKeys) {
      if (rendered.contains(key.toLowerCase())) continue;
      rendered.add(key.toLowerCase());

      var group = config.getGroupByCode(key);

      // Fallback options for Referral flow if backend config is empty or missing options
      if ((group == null || group.options.isEmpty) && isReferral) {
        if (key.contains('industry')) {
          group = const AskOptionGroupEntity(
            id: 'fallback_industry',
            code: 'referral_industry',
            name: 'Industry',
            description: 'Select industry',
            inputType: 'single_select',
            isMultiSelect: false,
            options: [
              AskOptionEntity(id: '1', code: 'auto_components', label: 'Auto components'),
              AskOptionEntity(id: '2', code: 'food', label: 'Food'),
              AskOptionEntity(id: '3', code: 'retail', label: 'Retail'),
              AskOptionEntity(id: '4', code: 'tech', label: 'Tech'),
              AskOptionEntity(id: '5', code: 'other', label: 'Other'),
            ],
          );
        } else if (key.contains('geography')) {
          group = const AskOptionGroupEntity(
            id: 'fallback_geography',
            code: 'referral_geography',
            name: 'Geography',
            description: 'Select geography',
            inputType: 'single_select',
            isMultiSelect: false,
            options: [
              AskOptionEntity(id: '1', code: 'my_city', label: 'My city'),
              AskOptionEntity(id: '2', code: 'india', label: 'India'),
              AskOptionEntity(id: '3', code: 'international', label: 'International'),
            ],
          );
        }
      }

      if (group != null && group.isActive && group.options.isNotEmpty) {
        final selected = _selectedFilterOptions[group.code] ?? <String>{};
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AskChoiceChipsGroup(
              group: group,
              selectedCodes: selected,
              onOptionToggled: (code) => _onOptionToggled(group!, code),
            ),
          ),
        );
      } else {
        final ctrl = _getController(key);
        final label = group != null && group.name.isNotEmpty
            ? group.name
            : _formatFilterLabel(key);
        final hint = group != null && group.description.isNotEmpty
            ? group.description
            : (key == 'expected_outcome'
                ? 'One line: what success looks like'
                : 'Enter ${label.toLowerCase()}');

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AskTextInputGroup(
              label: label,
              hintText: hint,
              controller: ctrl,
              onChanged: (_) => setState(() {}),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = widget.submission.formConfig ?? const AskFormConfigEntity();
    final isReferral = widget.submission.flow.code.toLowerCase() == 'referral';

    final headerTitle = isReferral ? 'Industry and geography' : 'A few filters';
    final headerSubtitle = isReferral ? 'Step 2 of 3' : 'Step 2 of 3 · Helps us find the right fit';
    final buttonLabel = isReferral ? 'Continue' : 'Preview my request';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppCommonBar(
        title: widget.submission.flow.name,
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            AskStepHeader(
              title: headerTitle,
              subtitle: headerSubtitle,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildFilterSections(config),
                ),
              ),
            ),
            AskBottomButton(
              label: buttonLabel,
              onPressed: _canContinue(config) ? _onPreview : null,
            ),
          ],
        ),
      ),
    );
  }
}
