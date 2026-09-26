import 'package:equatable/equatable.dart';

abstract class CircleJoinRequestStatusEvent extends Equatable {
  const CircleJoinRequestStatusEvent();

  @override
  List<Object?> get props => [];
}

class CircleJoinRequestStatusFetchRequested extends CircleJoinRequestStatusEvent {
  final String requestId;
  final String circleName;
  final bool silent;

  const CircleJoinRequestStatusFetchRequested({
    required this.requestId,
    required this.circleName,
    this.silent = false,
  });

  @override
  List<Object?> get props => [requestId, circleName, silent];
}

class CircleJoinRequestCancelRequested extends CircleJoinRequestStatusEvent {
  final String requestId;

  const CircleJoinRequestCancelRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class CircleJoinRequestPayRequested extends CircleJoinRequestStatusEvent {
  final String circleId;
  final String? paymentUrl;

  const CircleJoinRequestPayRequested({
    required this.circleId,
    this.paymentUrl,
  });

  @override
  List<Object?> get props => [circleId, paymentUrl];
}

class CircleJoinRequestMarkPaidRequested extends CircleJoinRequestStatusEvent {
  final String requestId;
  final String circleName;
  final bool silent;
  /// When true, calls mark-paid API regardless of current status (e.g., user returning from payment browser)
  final bool forceMarkPaid;

  const CircleJoinRequestMarkPaidRequested({
    required this.requestId,
    required this.circleName,
    this.silent = false,
    this.forceMarkPaid = false,
  });

  @override
  List<Object?> get props => [requestId, circleName, silent, forceMarkPaid];
}

class CircleJoinRequestClearPaymentLaunchUrl extends CircleJoinRequestStatusEvent {
  const CircleJoinRequestClearPaymentLaunchUrl();
}
