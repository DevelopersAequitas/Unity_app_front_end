import 'package:equatable/equatable.dart';

class MenuSummaryEntity extends Equatable {
  final int meetingRequestsCount;
  final int unreadCircularsCount;
  final int blockedUsersCount;
  final int pendingInvoicesCount;

  const MenuSummaryEntity({
    this.meetingRequestsCount = 0,
    this.unreadCircularsCount = 0,
    this.blockedUsersCount = 0,
    this.pendingInvoicesCount = 0,
  });

  @override
  List<Object?> get props => [
        meetingRequestsCount,
        unreadCircularsCount,
        blockedUsersCount,
        pendingInvoicesCount,
      ];
}
