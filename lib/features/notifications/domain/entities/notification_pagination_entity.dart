import 'package:equatable/equatable.dart';

class NotificationPaginationEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const NotificationPaginationEntity({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
