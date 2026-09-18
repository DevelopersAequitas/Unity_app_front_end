import '../../domain/entities/menu_summary_entity.dart';

class MenuSummaryModel extends MenuSummaryEntity {
  const MenuSummaryModel({
    super.meetingRequestsCount,
    super.unreadCircularsCount,
    super.blockedUsersCount,
    super.pendingInvoicesCount,
  });

  factory MenuSummaryModel.fromJson(Map<String, dynamic> json) {
    return MenuSummaryModel(
      meetingRequestsCount: json['meeting_requests_count'] as int? ??
          json['meetingRequestsCount'] as int? ??
          0,
      unreadCircularsCount: json['unread_circulars_count'] as int? ??
          json['unreadCircularsCount'] as int? ??
          0,
      blockedUsersCount: json['blocked_users_count'] as int? ??
          json['blockedUsersCount'] as int? ??
          0,
      pendingInvoicesCount: json['pending_invoices_count'] as int? ??
          json['pendingInvoicesCount'] as int? ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meeting_requests_count': meetingRequestsCount,
      'unread_circulars_count': unreadCircularsCount,
      'blocked_users_count': blockedUsersCount,
      'pending_invoices_count': pendingInvoicesCount,
    };
  }

  MenuSummaryEntity toEntity() => this;
}
