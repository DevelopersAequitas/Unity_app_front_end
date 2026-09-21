import '../../domain/entities/claim_coin_entity.dart';

class ClaimCoinModel {
  final String id;
  final String activityCode;
  final String activityLabel;
  final String status;
  final int coinsAwarded;
  final Map<String, dynamic> fields;
  final String? reviewNote;
  final String createdAt;
  final String? reviewedAt;

  const ClaimCoinModel({
    required this.id,
    required this.activityCode,
    required this.activityLabel,
    this.status = 'pending',
    this.coinsAwarded = 0,
    this.fields = const {},
    this.reviewNote,
    this.createdAt = '',
    this.reviewedAt,
  });

  factory ClaimCoinModel.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] is Map<String, dynamic>
        ? json['payload'] as Map<String, dynamic>
        : <String, dynamic>{};
    final parsedFields = payload['fields'] is Map<String, dynamic>
        ? payload['fields'] as Map<String, dynamic>
        : (json['fields'] is Map<String, dynamic> ? json['fields'] as Map<String, dynamic> : <String, dynamic>{});

    return ClaimCoinModel(
      id: json['id']?.toString() ?? '',
      activityCode: json['activity_code']?.toString() ?? json['activityCode']?.toString() ?? '',
      activityLabel: json['activity_label']?.toString() ??
          json['activity_title']?.toString() ??
          json['label']?.toString() ??
          'Coin Claim',
      status: json['status']?.toString() ?? 'pending',
      coinsAwarded: (json['coins_awarded'] ?? json['coins'] ?? json['coinsAwarded'] ?? 0) as int,
      fields: parsedFields,
      reviewNote: json['review_note']?.toString() ??
          json['reviewNote']?.toString() ??
          json['remarks']?.toString() ??
          json['admin_notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString() ?? json['date']?.toString() ?? '',
      reviewedAt: json['reviewed_at']?.toString() ?? json['reviewedAt']?.toString(),
    );
  }

  ClaimCoinEntity toEntity() {
    return ClaimCoinEntity(
      id: id,
      activityCode: activityCode,
      activityLabel: activityLabel,
      status: status,
      coinsAwarded: coinsAwarded,
      fields: fields,
      reviewNote: reviewNote,
      createdAt: createdAt,
      reviewedAt: reviewedAt,
    );
  }
}
