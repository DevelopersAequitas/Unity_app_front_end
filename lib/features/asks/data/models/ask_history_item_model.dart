import '../../domain/entities/ask_history_item_entity.dart';

class AskHistoryItemModel {
  final String id;
  final String askId;
  final String? fromStatus;
  final String toStatus;
  final String? reason;
  final String? changedBy;
  final String? createdAt;

  const AskHistoryItemModel({
    required this.id,
    required this.askId,
    this.fromStatus,
    required this.toStatus,
    this.reason,
    this.changedBy,
    this.createdAt,
  });

  factory AskHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return AskHistoryItemModel(
      id: (json['id'] ?? json['history_id'] ?? '').toString(),
      askId: (json['ask_id'] ?? '').toString(),
      fromStatus: json['from_status']?.toString(),
      toStatus: (json['to_status'] ?? json['status'] ?? 'unknown').toString(),
      reason: json['reason']?.toString() ?? json['note']?.toString(),
      changedBy: json['changed_by']?.toString() ?? json['user_id']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ask_id': askId,
      'from_status': fromStatus,
      'to_status': toStatus,
      'reason': reason,
      'changed_by': changedBy,
      'created_at': createdAt,
    };
  }

  AskHistoryItemEntity toEntity() {
    return AskHistoryItemEntity(
      id: id,
      askId: askId,
      fromStatus: fromStatus,
      toStatus: toStatus,
      reason: reason,
      changedBy: changedBy,
      createdAt: createdAt,
    );
  }
}
