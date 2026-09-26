import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/entities/ask_flow_entity.dart';
import '../../domain/entities/ask_form_config_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../../domain/entities/ask_type_entity.dart';
import '../bloc/ask_form_config/ask_form_config_bloc.dart';
import '../bloc/ask_form_config/ask_form_config_event.dart';
import '../bloc/ask_form_config/ask_form_config_state.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_choice_chips_group.dart';
import '../widgets/ask_step_header.dart';
import '../widgets/ask_step1_skeleton.dart';
import '../widgets/ask_text_input_group.dart';

class AskStep1BriefScreen extends StatefulWidget {
  final AskFlowEntity flow;
  final AskTypeEntity type;

  const AskStep1BriefScreen({
    super.key,
    required this.flow,
    required this.type,
  });

  @override
  State<AskStep1BriefScreen> createState() => _AskStep1BriefScreenState();
}

class _AskStep1BriefScreenState extends State<AskStep1BriefScreen> {
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, Set<String>> _selectedOptions = {};

  static const _helpDurationGroup = AskOptionGroupEntity(
    id: 'help_duration_group',
    code: 'help_duration',
    name: 'How much time do you need?',
    description: '',
    inputType: 'single_select',
    isMultiSelect: false,
    options: [
      AskOptionEntity(id: '1', code: '15_min', label: '15 min'),
      AskOptionEntity(id: '2', code: '1_hour', label: '1 hour'),
      AskOptionEntity(id: '3', code: 'half_day', label: 'Half a day'),
      AskOptionEntity(id: '4', code: 'ongoing', label: 'Ongoing'),
    ],
  );

  static const _helpTimingGroup = AskOptionGroupEntity(
    id: 'help_timing_group',
    code: 'help_timing',
    name: 'When do you need it?',
    description: '',
    inputType: 'single_select',
    isMultiSelect: false,
    options: [
      AskOptionEntity(id: '1', code: 'today', label: 'Today'),
      AskOptionEntity(id: '2', code: 'this_week', label: 'This week'),
      AskOptionEntity(id: '3', code: 'this_month', label: 'This month'),
      AskOptionEntity(id: '4', code: 'no_rush', label: 'No rush'),
    ],
  );

  @override
  void initState() {
    super.initState();
    final flowId = widget.flow.id.isNotEmpty ? widget.flow.id : widget.flow.code;
    final typeId = widget.type.id.isNotEmpty ? widget.type.id : widget.type.code;
    final isHelp = widget.flow.code.toLowerCase() == 'help' || widget.flow.code.toLowerCase() == 'advice';
    if (isHelp) {
      _selectedOptions['help_duration'] = {'1_hour'};
      _selectedOptions['help_timing'] = {'this_week'};
    }
    context.read<AskFormConfigBloc>().add(
          AskFormConfigFetchRequested(flowId: flowId, typeId: typeId),
        );
  }

  @override
  void dispose() {
    for (final ctrl in _textControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String key) {
    return _textControllers.putIfAbsent(key, () => TextEditingController());
  }

  String _getDurationLabel(String code) {
    switch (code.toLowerCase()) {
      case '15_min':
        return '15 min';
      case '1_hour':
        return '1 hour';
      case 'half_day':
      case 'half_a_day':
        return 'Half a day';
      case 'ongoing':
        return 'Ongoing';
      default:
        return code.replaceAll('_', ' ');
    }
  }

  String _getTimingLabel(String code) {
    switch (code.toLowerCase()) {
      case 'today':
        return 'Today';
      case 'this_week':
        return 'This week';
      case 'this_month':
        return 'This month';
      case 'no_rush':
        return 'No rush';
      default:
        return code.replaceAll('_', ' ');
    }
  }

  void _onOptionToggled(AskOptionGroupEntity group, String optionCode) {
    setState(() {
      final current = _selectedOptions[group.code] ?? <String>{};
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
      _selectedOptions[group.code] = current;
    });
  }

  String _formatLabel(String key) {
    switch (key.toLowerCase()) {
      case 'what_needed':
        return 'What do you need?';
      case 'done_definition':
        return 'What does "done" look like?';
      case 'who_to_meet':
        return 'Who do you want to meet?';
      case 'ideal_profile':
        return 'Ideal Profile';
      case 'referral_reason':
        return 'Reason for Referral';
      case 'what_i_offer':
        return 'What I offer';
      case 'goal':
        return 'Goal';
      case 'collaboration_bring':
        return 'What I bring';
      case 'collaboration_need':
        return 'What I need';
      case 'problem_statement':
      case 'help_summary':
        return 'What do you need help with?';
      default:
        return key
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
    }
  }

  String _formatHint(String key) {
    switch (key.toLowerCase()) {
      case 'what_needed':
        return 'One line. Start with a verb.';
      case 'done_definition':
        return 'How you will know it is finished';
      case 'who_to_meet':
        return 'e.g. Head of Procurement, Dealer Network Owner';
      case 'ideal_profile':
        return 'e.g. 5+ years experience in retail distribution';
      case 'referral_reason':
        return 'Why this introduction is valuable for both sides';
      case 'what_i_offer':
        return 'Your strength, product demo, or reciprocal intro';
      case 'goal':
        return 'One line: what this collaboration should achieve';
      default:
        return 'Enter ${_formatLabel(key).toLowerCase()}';
    }
  }

  bool _canContinue(AskFormConfigEntity config) {
    final isHelp = widget.flow.code.toLowerCase() == 'help' || widget.flow.code.toLowerCase() == 'advice';
    if (isHelp) {
      final whatNeeded = _textControllers['what_needed']?.text.trim() ??
          _textControllers['goal']?.text.trim() ??
          '';
      if (whatNeeded.isEmpty) return false;
      if ((_selectedOptions['help_duration'] ?? {}).isEmpty) return false;
      if ((_selectedOptions['help_timing'] ?? {}).isEmpty) return false;
      return true;
    }

    final isReferral = widget.flow.code.toLowerCase() == 'referral';
    List<String> detailKeys = config.detailSectionKeys;
    if (isReferral) {
      detailKeys = detailKeys
          .where((k) =>
              k != 'referral_reason' &&
              k != 'what_i_offer' &&
              k != 'referral_industry' &&
              k != 'referral_geography' &&
              k != 'industry' &&
              k != 'geography')
          .toList();
      if (detailKeys.isEmpty) {
        detailKeys = const ['who_to_meet', 'ideal_profile'];
      }
    } else if (detailKeys.isEmpty) {
      final filterKeySet = config.filterSectionKeys.toSet();
      final nonFilterGroupCodes = config.groups
          .where((g) => !filterKeySet.contains(g.code))
          .map((g) => g.code)
          .toList();
      detailKeys = nonFilterGroupCodes.isNotEmpty
          ? nonFilterGroupCodes
          : const ['goal', 'collaboration_bring', 'collaboration_need'];
    }

    final rendered = <String>{};
    for (final key in detailKeys) {
      if (rendered.contains(key.toLowerCase())) continue;
      rendered.add(key.toLowerCase());

      final group = config.getGroupByCode(key);
      if (group != null && group.isActive && group.options.isNotEmpty) {
        if ((_selectedOptions[group.code] ?? {}).isEmpty) {
          return false;
        }
      } else {
        final ctrl = _textControllers[key];
        if (ctrl == null || ctrl.text.trim().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _onContinue() {
    final isHelp = widget.flow.code.toLowerCase() == 'help' || widget.flow.code.toLowerCase() == 'advice';
    final isReferral = widget.flow.code.toLowerCase() == 'referral';
    final configState = context.read<AskFormConfigBloc>().state;
    final customAnswers = <String, dynamic>{};
    for (final entry in _textControllers.entries) {
      if (entry.value.text.trim().isNotEmpty) {
        customAnswers[entry.key] = entry.value.text.trim();
      }
    }
    for (final entry in _selectedOptions.entries) {
      if (entry.value.isNotEmpty) {
        customAnswers[entry.key] = entry.value.toList();
      }
    }

    if (isReferral) {
      customAnswers.remove('referral_reason');
      customAnswers.remove('what_i_offer');
    }

    if (isHelp) {
      final whatNeeded = _textControllers['what_needed']?.text.trim() ??
          _textControllers['goal']?.text.trim() ??
          '';
      final doneDefinition = _textControllers['done_definition']?.text.trim() ?? '';
      final durationCode = _selectedOptions['help_duration']?.firstOrNull ?? '1_hour';
      final timingCode = _selectedOptions['help_timing']?.firstOrNull ?? 'this_week';
      final durationLabel = _getDurationLabel(durationCode);
      final timingLabel = _getTimingLabel(timingCode);

      if (whatNeeded.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please describe what you need.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      customAnswers['what_needed'] = whatNeeded;
      customAnswers['goal'] = whatNeeded;
      customAnswers['done_definition'] = doneDefinition;
      customAnswers['help_duration'] = durationLabel;
      customAnswers['help_timing'] = timingLabel;
      customAnswers['help_duration_code'] = durationCode;
      customAnswers['help_timing_code'] = timingCode;

      final submission = AskSubmissionEntity(
        flow: widget.flow,
        type: widget.type,
        goal: whatNeeded,
        timeline: timingLabel,
        expectedOutcome: doneDefinition,
        formConfig: configState.config,
        customAnswers: customAnswers,
      );

      Navigator.of(context).pushNamed(
        AppRoutes.askPreview,
        arguments: submission,
      );
      return;
    }

    final goalText = _textControllers['goal']?.text.trim() ??
        _textControllers['who_to_meet']?.text.trim() ??
        '';

    final submission = AskSubmissionEntity(
      flow: widget.flow,
      type: widget.type,
      goal: goalText,
      whatIBring: (_selectedOptions['collaboration_bring'] ??
              _selectedOptions['bring'] ??
              {})
          .toList(),
      whatINeed: (_selectedOptions['collaboration_need'] ??
              _selectedOptions['need'] ??
              {})
          .toList(),
      formConfig: configState.config,
      customAnswers: customAnswers,
    );

    Navigator.of(context).pushNamed(
      AppRoutes.askFilters,
      arguments: submission,
    );
  }

  List<Widget> _buildSections(AskFormConfigEntity config) {
    final isHelp = widget.flow.code.toLowerCase() == 'help' || widget.flow.code.toLowerCase() == 'advice';
    if (isHelp) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AskTextInputGroup(
            label: 'What do you need?',
            hintText: 'One line. Start with a verb.',
            controller: _getController('what_needed'),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AskTextInputGroup(
            label: 'What does "done" look like?',
            hintText: 'How you will know it is finished',
            controller: _getController('done_definition'),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AskChoiceChipsGroup(
            group: _helpDurationGroup,
            selectedCodes: _selectedOptions['help_duration'] ?? {'1_hour'},
            onOptionToggled: (code) => _onOptionToggled(_helpDurationGroup, code),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AskChoiceChipsGroup(
            group: _helpTimingGroup,
            selectedCodes: _selectedOptions['help_timing'] ?? {'this_week'},
            onOptionToggled: (code) => _onOptionToggled(_helpTimingGroup, code),
          ),
        ),
      ];
    }

    final isReferral = widget.flow.code.toLowerCase() == 'referral';
    final widgets = <Widget>[];
    List<String> detailKeys = config.detailSectionKeys;

    if (isReferral) {
      detailKeys = detailKeys
          .where((k) =>
              k != 'referral_reason' &&
              k != 'what_i_offer' &&
              k != 'referral_industry' &&
              k != 'referral_geography' &&
              k != 'industry' &&
              k != 'geography')
          .toList();
      if (detailKeys.isEmpty) {
        detailKeys = const ['who_to_meet', 'ideal_profile'];
      }
    } else if (detailKeys.isEmpty) {
      final filterKeySet = config.filterSectionKeys.toSet();
      final nonFilterGroupCodes = config.groups
          .where((g) => !filterKeySet.contains(g.code))
          .map((g) => g.code)
          .toList();
      detailKeys = nonFilterGroupCodes.isNotEmpty
          ? nonFilterGroupCodes
          : const ['goal', 'collaboration_bring', 'collaboration_need'];
    }

    final rendered = <String>{};

    for (final key in detailKeys) {
      if (rendered.contains(key.toLowerCase())) continue;
      rendered.add(key.toLowerCase());

      final group = config.getGroupByCode(key);

      if (group != null && group.isActive && group.options.isNotEmpty) {
        final selected = _selectedOptions[group.code] ?? <String>{};
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AskChoiceChipsGroup(
              group: group,
              selectedCodes: selected,
              onOptionToggled: (code) => _onOptionToggled(group, code),
            ),
          ),
        );
      } else {
        final ctrl = _getController(key);
        final label = group != null && group.name.isNotEmpty
            ? group.name
            : _formatLabel(key);
        final hint = group != null && group.description.isNotEmpty
            ? group.description
            : _formatHint(key);

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
    final isHelp = widget.flow.code.toLowerCase() == 'help' || widget.flow.code.toLowerCase() == 'advice';
    final flowId = widget.flow.id.isNotEmpty ? widget.flow.id : widget.flow.code;
    final typeId = widget.type.id.isNotEmpty ? widget.type.id : widget.type.code;

    final headerTitle = isHelp ? 'Tell us what you need' : 'What are you trying to achieve?';
    final headerSubtitle = isHelp
        ? 'One clear ask gets faster help'
        : 'A clear brief gets better matches. Two lines is enough.';
    final buttonLabel = isHelp ? 'Preview and post' : 'Continue';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppCommonBar(
        title: widget.flow.name,
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
              child: BlocBuilder<AskFormConfigBloc, AskFormConfigState>(
                builder: (context, state) {
                  if (state.status == AskFormConfigStatus.loading &&
                      state.config.groups.isEmpty &&
                      state.config.detailSectionKeys.isEmpty &&
                      !isHelp) {
                    return const AskStep1Skeleton();
                  }

                  if (state.status == AskFormConfigStatus.error &&
                      state.config.groups.isEmpty &&
                      state.config.detailSectionKeys.isEmpty &&
                      !isHelp) {
                    return AppErrorView(
                      title: 'Unable to Load Form',
                      message: state.errorMessage ?? 'Please check your connection.',
                      onRetry: () => context.read<AskFormConfigBloc>().add(
                            AskFormConfigFetchRequested(
                              flowId: flowId,
                              typeId: typeId,
                            ),
                          ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildSections(state.config),
                          ),
                        ),
                      ),
                      AskBottomButton(
                        label: buttonLabel,
                        onPressed: _canContinue(state.config) ? _onContinue : null,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
