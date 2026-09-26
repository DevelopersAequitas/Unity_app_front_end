import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_join_request_entity.dart';

enum CircleJoinRequestStatusStateStatus {
  initial,
  loading,
  success,
  cancelling,
  cancelled,
  error
}

class CircleJoinRequestStatusState extends Equatable {
  final CircleJoinRequestStatusStateStatus status;
  final CircleJoinRequestEntity? request;
  final bool isGeneratingCheckout;
  final String? paymentLaunchUrl;
  final String? errorMessage;

  const CircleJoinRequestStatusState({
    this.status = CircleJoinRequestStatusStateStatus.initial,
    this.request,
    this.isGeneratingCheckout = false,
    this.paymentLaunchUrl,
    this.errorMessage,
  });

  CircleJoinRequestStatusState copyWith({
    CircleJoinRequestStatusStateStatus? status,
    CircleJoinRequestEntity? request,
    bool? isGeneratingCheckout,
    String? paymentLaunchUrl,
    bool clearPaymentLaunchUrl = false,
    String? errorMessage,
  }) {
    return CircleJoinRequestStatusState(
      status: status ?? this.status,
      request: request ?? this.request,
      isGeneratingCheckout: isGeneratingCheckout ?? this.isGeneratingCheckout,
      paymentLaunchUrl: clearPaymentLaunchUrl
          ? null
          : (paymentLaunchUrl ?? this.paymentLaunchUrl),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        isGeneratingCheckout,
        paymentLaunchUrl,
        errorMessage,
      ];
}
