import 'package:equatable/equatable.dart';

class AskHistoryItemEntity extends Equatable {
  final String id;
  final String askId;
  final String? fromStatus;
  final String toStatus;
  final String? reason;
  final String? changedBy;
  final String? createdAt;

  const AskHistoryItemEntity({
    required this.id,
    required this.askId,
    this.fromStatus,
    required this.toStatus,
    this.reason,
    this.changedBy,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        askId,
        fromStatus,
        toStatus,
        reason,
        changedBy,
        createdAt,
      ];
}
