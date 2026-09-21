import '../../domain/entities/life_impact_entity.dart';
import 'life_impact_user_model.dart';

class LifeImpactModel {
  final String id;
  final String activityType;
  final int impactValue;
  final int impactAfter;
  final String changeType;
  final String actionKey;
  final String actionLabel;
  final String title;
  final String description;
  final String remarks;
  final LifeImpactUserModel? performedBy;
  final LifeImpactUserModel? affectedUser;
  final LifeImpactUserModel? triggeredByUser;
  final Map<String, dynamic> activityDetails;
  final String? activityId;
  final String createdAt;

  const LifeImpactModel({
    required this.id,
    this.activityType = '',
    this.impactValue = 1,
    this.impactAfter = 0,
    this.changeType = 'increased',
    this.actionKey = '',
    this.actionLabel = '',
    required this.title,
    this.description = '',
    this.remarks = '',
    this.performedBy,
    this.affectedUser,
    this.triggeredByUser,
    this.activityDetails = const {},
    this.activityId,
    this.createdAt = '',
  });

  factory LifeImpactModel.fromJson(Map<String, dynamic> json) {
    final titleRaw = json['title']?.toString() ??
        json['action_label']?.toString() ??
        json['activity_name']?.toString() ??
        'Life Impact';
    final descRaw = json['description']?.toString() ??
        json['story_to_share']?.toString() ??
        '';
    final remarksRaw = json['remarks']?.toString() ?? '';
    final activityTypeRaw = json['activity_type']?.toString() ??
        json['action_key']?.toString() ??
        '';
    final actionLabelRaw = json['action_label']?.toString() ??
        json['category']?.toString() ??
        '';
    final pts = (json['impact_value'] ?? json['impact'] ?? json['points'] ?? 1) as num;
    final impactAfter = (json['impact_after'] as num?)?.toInt() ?? 0;
    final changeType = json['change_type']?.toString() ?? 'increased';
    final dateRaw = json['created_at']?.toString() ?? json['date']?.toString() ?? '';

    return LifeImpactModel(
      id: json['id']?.toString() ?? '',
      activityType: activityTypeRaw,
      impactValue: pts.toInt(),
      impactAfter: impactAfter,
      changeType: changeType,
      actionKey: json['action_key']?.toString() ?? activityTypeRaw,
      actionLabel: actionLabelRaw,
      title: titleRaw,
      description: descRaw,
      remarks: remarksRaw,
      performedBy: json['performed_by'] is Map<String, dynamic>
          ? LifeImpactUserModel.fromJson(json['performed_by'] as Map<String, dynamic>)
          : null,
      affectedUser: json['affected_user'] is Map<String, dynamic>
          ? LifeImpactUserModel.fromJson(json['affected_user'] as Map<String, dynamic>)
          : null,
      triggeredByUser: json['triggered_by_user'] is Map<String, dynamic>
          ? LifeImpactUserModel.fromJson(json['triggered_by_user'] as Map<String, dynamic>)
          : null,
      activityDetails: json['activity_details'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['activity_details'] as Map)
          : {},
      activityId: json['activity_id']?.toString(),
      createdAt: dateRaw,
    );
  }

  LifeImpactEntity toEntity() {
    return LifeImpactEntity(
      id: id,
      activityType: activityType,
      impactValue: impactValue,
      impactAfter: impactAfter,
      changeType: changeType,
      actionKey: actionKey,
      actionLabel: actionLabel,
      title: title,
      description: description,
      remarks: remarks,
      performedBy: performedBy?.toEntity(),
      affectedUser: affectedUser?.toEntity(),
      triggeredByUser: triggeredByUser?.toEntity(),
      activityDetails: activityDetails,
      activityId: activityId,
      createdAt: createdAt,
    );
  }
}
