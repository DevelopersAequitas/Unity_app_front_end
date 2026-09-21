import 'package:equatable/equatable.dart';
import 'life_impact_user_entity.dart';

class LifeImpactEntity extends Equatable {
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
  final LifeImpactUserEntity? performedBy;
  final LifeImpactUserEntity? affectedUser;
  final LifeImpactUserEntity? triggeredByUser;
  final Map<String, dynamic> activityDetails;
  final String? activityId;
  final String createdAt;

  const LifeImpactEntity({
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

  @override
  List<Object?> get props => [
        id,
        activityType,
        impactValue,
        impactAfter,
        changeType,
        actionKey,
        actionLabel,
        title,
        description,
        remarks,
        performedBy,
        affectedUser,
        triggeredByUser,
        activityDetails,
        activityId,
        createdAt,
      ];
}
