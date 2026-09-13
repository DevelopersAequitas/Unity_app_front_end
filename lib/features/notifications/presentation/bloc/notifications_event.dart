import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsFetchRequested extends NotificationsEvent {
  const NotificationsFetchRequested();
}

class NotificationsRefreshRequested extends NotificationsEvent {
  const NotificationsRefreshRequested();
}

class NotificationsLoadMoreRequested extends NotificationsEvent {
  const NotificationsLoadMoreRequested();
}

class NotificationMarkReadRequested extends NotificationsEvent {
  final String id;
  const NotificationMarkReadRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class NotificationsMarkAllReadRequested extends NotificationsEvent {
  const NotificationsMarkAllReadRequested();
}

class NotificationsFilterChanged extends NotificationsEvent {
  final String filter;
  const NotificationsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
