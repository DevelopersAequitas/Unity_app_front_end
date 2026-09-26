import 'package:equatable/equatable.dart';
import 'ask_flow_entity.dart';
import 'ask_form_config_entity.dart';
import 'ask_type_entity.dart';

class AskSubmissionEntity extends Equatable {
  final String? askId;
  final AskFlowEntity flow;
  final AskTypeEntity type;
  final String goal;
  final List<String> whatIBring;
  final List<String> whatINeed;
  final String? industry;
  final String? geography;
  final String? businessStage;
  final String? timeline;
  final String expectedOutcome;
  final String visibility; // 'global', 'district', 'circle'
  final bool postToTimeline;
  final AskFormConfigEntity? formConfig;
  final Map<String, dynamic> customAnswers;

  const AskSubmissionEntity({
    this.askId,
    required this.flow,
    required this.type,
    this.goal = '',
    this.whatIBring = const [],
    this.whatINeed = const [],
    this.industry,
    this.geography,
    this.businessStage,
    this.timeline,
    this.expectedOutcome = '',
    this.visibility = 'district',
    this.postToTimeline = true,
    this.formConfig,
    this.customAnswers = const {},
  });

  String get effectiveGoal {
    if (goal.trim().isNotEmpty) return goal.trim();
    final who = (customAnswers['who_to_meet'] ?? '').toString().trim();
    if (who.isNotEmpty) return 'Looking to connect with $who';
    final reason = (customAnswers['referral_reason'] ?? '').toString().trim();
    if (reason.isNotEmpty) return reason;
    final ideal = (customAnswers['ideal_profile'] ?? '').toString().trim();
    if (ideal.isNotEmpty) return 'Seeking $ideal';
    return '${flow.name} for ${type.name}';
  }

  AskSubmissionEntity copyWith({
    String? askId,
    AskFlowEntity? flow,
    AskTypeEntity? type,
    String? goal,
    List<String>? whatIBring,
    List<String>? whatINeed,
    String? industry,
    String? geography,
    String? businessStage,
    String? timeline,
    String? expectedOutcome,
    String? visibility,
    bool? postToTimeline,
    AskFormConfigEntity? formConfig,
    Map<String, dynamic>? customAnswers,
  }) {
    return AskSubmissionEntity(
      askId: askId ?? this.askId,
      flow: flow ?? this.flow,
      type: type ?? this.type,
      goal: goal ?? this.goal,
      whatIBring: whatIBring ?? this.whatIBring,
      whatINeed: whatINeed ?? this.whatINeed,
      industry: industry ?? this.industry,
      geography: geography ?? this.geography,
      businessStage: businessStage ?? this.businessStage,
      timeline: timeline ?? this.timeline,
      expectedOutcome: expectedOutcome ?? this.expectedOutcome,
      visibility: visibility ?? this.visibility,
      postToTimeline: postToTimeline ?? this.postToTimeline,
      formConfig: formConfig ?? this.formConfig,
      customAnswers: customAnswers ?? this.customAnswers,
    );
  }

  @override
  List<Object?> get props => [
        askId,
        flow,
        type,
        goal,
        whatIBring,
        whatINeed,
        industry,
        geography,
        businessStage,
        timeline,
        expectedOutcome,
        visibility,
        postToTimeline,
        formConfig,
        customAnswers,
      ];
}
