import 'package:equatable/equatable.dart';

class ClaimCoinEntity extends Equatable {
  final String id;
  final String activityCode;
  final String activityLabel;
  final String status;
  final int coinsAwarded;
  final Map<String, dynamic> fields;
  final String? reviewNote;
  final String createdAt;
  final String? reviewedAt;

  const ClaimCoinEntity({
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

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';

  String get subtitle {
    if (fields.containsKey('new_member_name')) {
      return 'New peer: ${fields['new_member_name']}';
    } else if (fields.containsKey('visitor_name')) {
      return 'Visitor: ${fields['visitor_name']}';
    } else if (fields.containsKey('circle_name')) {
      return 'Circle: ${fields['circle_name']}';
    } else if (fields.containsKey('meeting_date')) {
      return 'Meeting date: ${fields['meeting_date']}';
    } else if (fields.containsKey('visit_date')) {
      return 'Visit date: ${fields['visit_date']}';
    } else if (fields.containsKey('joining_date')) {
      return 'Joining date: ${fields['joining_date']}';
    } else if (fields.containsKey('renewal_date')) {
      return 'Renewal date: ${fields['renewal_date']}';
    } else if (fields.containsKey('spotlight_date')) {
      return 'Spotlight date: ${fields['spotlight_date']}';
    } else if (fields.containsKey('story_url')) {
      return 'Story: ${fields['story_url']}';
    } else if (fields.containsKey('description')) {
      return fields['description'].toString();
    }
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        activityCode,
        activityLabel,
        status,
        coinsAwarded,
        fields,
        reviewNote,
        createdAt,
        reviewedAt,
      ];
}
